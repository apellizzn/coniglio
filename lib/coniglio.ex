defmodule Coniglio do
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

  def listen do
    c =
      %RabbitClient{brokerUrl: "amqp://localhost:5672", timeout: 1000}
      |> RabbitClient.connect()

    RabbitClient.listen(c, context(), "world", exchange: "hello")
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
