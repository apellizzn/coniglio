defmodule Main do
  require Logger
  use Coniglio


  def try do
    Coniglio.Service.start_link([
      listeners: [SayHi],
      broker_url: "amqp://localhost:5672",
      timeout: 1000
    ])
  end

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
    |> Logger.info
  end

  def listen do
    Service.new_service(name: "Receiver", timeout: 1000)
    |> Service.add_listener("exhello", "toworld", Consume)
  end

  def dialog do
    {:ok, client} =
      %Coniglio.RabbitClient{broker_url: "amqp://localhost:5672", timeout: 1000}
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
      client = %Coniglio.RabbitClient{broker_url: "amqp://localhost:5672", timeout: 1000}
      |> Coniglio.RabbitClient.connect()

      client
      |> Coniglio.RabbitClient.cast(context(), %Delivery{
        exchange: "say_hi_exchange",
        routing_key: "say_hi_topic",
        body: Message.encode(Message.new(name: "Albe")),
        headers: []
      })
      Coniglio.RabbitClient.stop(client)
  end
end
