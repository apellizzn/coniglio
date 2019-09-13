defmodule Coniglio.RabbitClient.Client do
  @moduledoc """
    Coniglio.RabbitClient.Client

    This module is used to comunicate with a Rabbitmq instance
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

      @doc """
        Get the client configuraion
      """
      def get do
        GenServer.call(__MODULE__, :get_client)
      end

      @doc """
        Fire and forget action, publish a message to an exchange + topic
      """
      @spec publish(Coniglio.Context.t(), Coniglio.Delivery.t()) :: :ok
      def publish(ctx, request) do
        GenServer.cast(__MODULE__, {:publish, ctx, request})
      end

      @doc """
        Request / Response action, publish a message to an exchange + topic and
        wait for the response
      """
      @spec publish(Coniglio.Context.t(), Coniglio.Delivery.t()) :: term
      def request(ctx, request) do
        GenServer.call(__MODULE__, {:request, ctx, request})
      end

      @doc """
        Creates a queue and binds it to an exchange
        wait for the response
      """
      @spec bind_exchange(String.t(), String.t(), String.t()) :: term
      def bind_exchange(prefix, exchange, topic) do
        GenServer.call(__MODULE__, {:bind_exchange, prefix, exchange, topic})
      end

      @doc """
        Stops the client by closing its connection to the Rabbitmq instance
      """
      @spec stop() :: :ok
      def stop() do
        GenServer.cast(__MODULE__, :stop)
      end

      @spec register_consumer(String.t(), Keyword.t()) :: term
      def register_consumer(queue, opts \\ []) do
        GenServer.call(__MODULE__, {:register_consumer, queue, opts})
      end

      defoverridable init: 1
    end
  end
end
