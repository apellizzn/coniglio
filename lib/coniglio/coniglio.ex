defmodule Coniglio do
  @moduledoc """
    Coniglio
  """
  defmacro __using__(_opts) do
    quote do
      alias Coniglio.Context
      alias Coniglio.RabbitClient
      alias Coniglio.RabbitClient.Delivery
      alias Coniglio.Service
    end
  end
end
