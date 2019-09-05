defmodule Coniglio do
  require Logger

  @moduledoc """
  Documentation for Coniglio.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Coniglio.hello()
      :world

  """

  defp context do
    %Context{correlation_id: "123", reply_to: "amq.rabbitmq.reply-to"}
  end

  @spec consume(Delivery.t()) :: any
  def consume(delivery) do
    Logger.info("Received a message")
    IO.inspect(delivery)
    IO.inspect(Message.decode(delivery.body))
  end

  def listen do
    %RabbitClient{brokerUrl: "amqp://localhost:5672", timeout: 1000}
    |> RabbitClient.connect()
    |> RabbitClient.listen(context(), "world",
      exchange: "hello",
      handler: &consume/1
    )
  end

  def publish do
    %RabbitClient{brokerUrl: "amqp://localhost:5672", timeout: 1000}
    |> RabbitClient.connect()
    |> RabbitClient.cast(context(), %Delivery{
      exchange: "hello",
      routing_key: "world",
      body: Message.encode(Message.new(name: "Albe")),
      headers: []
    })
  end
end
