defmodule Coniglio do
  @moduledoc """
  Documentation for Lapin.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Coniglio.hello()
      :world

  """
  def hello do
    %RabbitClient{brokerUrl: "amqp://localhost:5672", timeout: 1000}
    |> RabbitClient.connect()
    |> RabbitClient.stop()
  end
end
