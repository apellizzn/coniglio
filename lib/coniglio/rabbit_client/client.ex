defmodule Coniglio.RabbitClient.Client do
  @moduledoc """
    Coniglio.RabbitClient.Client
  """
  @callback get() :: Coniglio.RabbitClient.Client.t()
  @callback stop() :: :ok | {:error, any}
  @callback publish(
              Coniglio.Context.t(),
              Coniglio.RabbitClient.Delivery.t()
            ) :: :ok | :error
  @callback request(
              Coniglio.Context.t(),
              Coniglio.RabbitClient.Delivery.t()
            ) :: Coniglio.RabbitClient.Delivery.t()
  @callback bind_exchange(String.t(), String.t(), String.t()) ::
              :ok | {:error, String.t()}
end
