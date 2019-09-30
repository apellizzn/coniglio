defmodule Coniglio.Client do
  @client Application.get_env(:coniglio, :client, Coniglio.RealClient)
  use GenServer

  def start_link(opts) do
    @client.start_link(opts)
  end

  def get do
    @client.get()
  end

  @spec publish(Coniglio.Context.t(), Coniglio.Delivery.t()) :: :ok
  def publish(ctx, request) do
    @client.publish(ctx, request)
  end

  @spec request(Coniglio.Context.t(), Coniglio.Delivery.t()) :: term
  def request(ctx, request) do
    @client.request(ctx, request)
  end

  @spec bind_exchange(String.t(), String.t(), String.t()) :: term
  def bind_exchange(prefix, exchange, topic) do
    @client.bind_exchange(prefix, exchange, topic)
  end

  @spec stop() :: :ok
  def stop() do
    @client.stop()
  end

  @spec register_consumer(String.t(), Keyword.t()) :: term
  def register_consumer(queue, opts \\ []) do
    @client.register_consumer(queue, opts)
  end
end
