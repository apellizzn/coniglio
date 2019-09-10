defmodule Coniglio.RabbitClient.MessageHandler do
  @moduledoc """
    Coniglio.RabbitClient.MessageHandler
  """
  @callback handle(Coniglio.RabbitClient.Delivery.t()) :: byte()
end
