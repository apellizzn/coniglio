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
  def test do
    c =
      %RabbitClient{brokerUrl: "amqp://localhost:5672", timeout: 1000}
      |> RabbitClient.connect()

    RabbitClient.listen(c, %{}, "world", exchange: "hello")
  end
end
