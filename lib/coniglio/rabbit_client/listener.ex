defmodule Coniglio.Listener do
  @callback exchange() :: String.t()
  @callback topic() :: String.t()
  @callback handle(Coniglio.RabbitClient.Delivery.t()) :: byte()
end
