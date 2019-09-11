defmodule Coniglio.RabbitClient.Client do
  @moduledoc """
    Coniglio.RabbitClient.Client
  """
  defmacro __using__(_args) do
    quote do
      use GenServer

      def start_link(opts) do
        GenServer.start_link(__MODULE__, opts, name: __MODULE__)
      end

      def init(opts) do
        {:ok, opts}
      end

      def get do
        GenServer.call(__MODULE__, :get_client)
      end

      def publish(ctx, request) do
        GenServer.cast(__MODULE__, {:publish, ctx, request})
      end

      def request(ctx, request) do
        GenServer.call(__MODULE__, {:request, ctx, request})
      end

      def bind_exchange(prefix, exchange, topic) do
        GenServer.call(__MODULE__, {:bind_exchange, prefix, exchange, topic})
      end

      def stop() do
        GenServer.cast(__MODULE__, :stop)
      end

      def register_consumer(queue) do
        GenServer.call(__MODULE__, {:register_consumer, queue})
      end

      defoverridable init: 1
    end
  end
end
