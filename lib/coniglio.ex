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
    %Context{correlation_id: "123"}
  end

  @spec consume(Delivery.t()) :: any
  def consume(delivery) do
    Logger.info("Received a message")
    IO.inspect(delivery)
    IO.inspect(Message.decode(delivery.body))
  end

  def listen do
    Service.new_service(name: "Receiver", timeout: 1000)
    |> Service.add_listener("exhello", "toworld", &consume/1)
  end

  def publish do
    r =
      %RabbitClient{brokerUrl: "amqp://localhost:5672", timeout: 1000}
      |> RabbitClient.connect()

    RabbitClient.cast(r, context(), %Delivery{
      exchange: "exhello",
      routing_key: "toworld",
      body: Message.encode(Message.new(name: "Albe")),
      headers: []
    })

    RabbitClient.stop(r)
  end
end
