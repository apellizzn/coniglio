defmodule Coniglio.Contracts.Client do
  @moduledoc """
    Coniglio.Contracts.Client
  """
  @callback new_client(String.t(), Integer.t()) :: Coniglio.Contracts.Client.t()
  @callback connect(Coniglio.Contracts.Client.t()) ::
              {:ok, Coniglio.Contracts.Client.t()} | {:error, String.t()}

  @callback stop(Coniglio.Contracts.Client.t()) :: :ok | {:error, any}
  @callback cast(
              Coniglio.Contracts.Client.t(),
              Coniglio.Context.t(),
              Coniglio.RabbitClient.Delivery.t()
            ) :: :ok | :error
  @callback listen(Coniglio.Contracts.Client.t(), Coniglio.Context.t(), String.t(), [any()]) ::
              {:ok, pid()} | {:error, binary()}
  @callback call(
              Coniglio.Contracts.Client.t(),
              Coniglio.Context.t(),
              Coniglio.RabbitClient.Delivery.t()
            ) :: Coniglio.RabbitClient.Delivery.t()
  @callback add_consumer(Coniglio.Contracts.Client.t(), String.t()) ::
              Coniglio.Contracts.Client.t()

  @callback bind_exchange(String.t(), String.t(), String.t(), String.t()) ::
              :ok | {:error, String.t()}
end
