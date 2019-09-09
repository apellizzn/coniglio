defmodule Coniglio.RabbitClient.MessageHandler do
  @callback handle(Coniglio.RabbitClient.Delivery.t()) :: byte()
end
