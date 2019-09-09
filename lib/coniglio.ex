defmodule Coniglio do
  require Logger

  defp context do
    %Context{correlation_id: "123"}
  end

  @spec consume(Delivery.t()) :: byte()
  def consume(delivery) do
    IO.puts("Received message")

    delivery.body
    |> Message.decode()
    |> Map.merge(%{last_name: "Pell"})
    |> Message.encode()
  end

  @spec log(Delivery.t()) :: any
  def log(delivery) do
    delivery.body
    |> Message.decode()
    |> IO.inspect()
  end

  def listen do
    Service.new_service(name: "Receiver", timeout: 1000)
    |> Service.add_listener("exhello", "toworld", &consume/1)
  end

  def dialog do
    {:ok, client} =
      %RabbitClient{brokerUrl: "amqp://localhost:5672", timeout: 1000}
      |> RabbitClient.connect()

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
      %RabbitClient{brokerUrl: "amqp://localhost:5672", timeout: 1000}
      |> RabbitClient.connect()

    RabbitClient.cast(client, context(), %Delivery{
      exchange: "exhello",
      routing_key: "toworld",
      body: Message.encode(Message.new(name: "Albe")),
      headers: []
    })

    RabbitClient.stop(client)
  end
end
