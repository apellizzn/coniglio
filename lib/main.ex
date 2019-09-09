defmodule Main do
  require Logger
  use Coniglio

  defmodule Consume do
    @behaviour Coniglio.RabbitClient.MessageHandler

    def handle(delivery) do
      IO.puts("Received message")

      delivery.body
      |> Message.decode()
      |> Map.merge(%{last_name: "Pell"})
      |> Message.encode()
    end
  end

  defp context do
    %Context{correlation_id: "123"}
  end

  @spec log(Delivery.t()) :: any
  def log(delivery) do
    delivery.body
    |> Message.decode()
    |> IO.inspect()
  end

  def listen do
    Service.new_service(name: "Receiver", timeout: 1000)
    |> Service.add_listener("exhello", "toworld", Consume)
  end

  def dialog do
    {:ok, client} =
      %Coniglio.RabbitClient{brokerUrl: "amqp://localhost:5672", timeout: 1000}
      |> Coniglio.RabbitClient.connect()

    RabbitClient.call(client, context(), %Delivery{
      exchange: "exhello",
      routing_key: "toworld",
      body: Message.encode(Message.new(name: "Albe")),
      headers: []
    })
    |> log
  end

  def publish do
    {:ok, client} =
      %Coniglio.RabbitClient{brokerUrl: "amqp://localhost:5672", timeout: 1000}
      |> Coniglio.RabbitClient.connect()

    Coniglio.RabbitClient.cast(client, context(), %Delivery{
      exchange: "exhello",
      routing_key: "toworld",
      body: Message.encode(Message.new(name: "Albe")),
      headers: []
    })

    Coniglio.RabbitClient.stop(client)
  end
end
