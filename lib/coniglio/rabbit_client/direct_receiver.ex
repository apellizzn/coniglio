defmodule Coniglio.RabbitClient.DirectReceiver do
  @moduledoc """
    Coniglio.RabbitClient.DirectReceiver

    This module is responsible of collecting messages on the direct reply to
    queue and forwording them to the waiting process
  """

  use GenServer
  use AMQP
  use Coniglio
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: String.to_atom(opts[:consumer_tag]))
  end

  @spec init([
          {:channel, AMQP.Channel.t()},
          {:receiver, pid()},
          {:ctx, Coniglio.Context.t()},
          {:consumer_tag, String.t()}
        ]) :: {:ok, {AMQP.Channel.t(), pid(), String.t()}} | {:stop, :error}
  def init(opts) do
    channel = opts[:channel]
    receiver = opts[:receiver]
    consumer_tag = opts[:consumer_tag]

    case AMQP.Basic.consume(channel, opts[:queue], self(),
           consumer_tag: consumer_tag,
           no_ack: true
         ) do
      {:ok, _} -> {:ok, {channel, receiver, consumer_tag}}
      _ -> {:stop, :error}
    end
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, state) do
    Logger.info("Direct receiver #{consumer_tag} registered")
    {:noreply, state}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, state) do
    Logger.info("Consumer #{consumer_tag} cancelled")
    {:stop, :normal, state}
  end

  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, state) do
    Logger.info("Consumer #{consumer_tag} cancelled")
    {:noreply, state}
  end

  def handle_info(
        {:basic_deliver, payload, meta},
        {channel, receiver, consumer_tag}
      ) do
    AMQP.Basic.cancel(channel, consumer_tag)

    GenServer.reply(
      receiver,
      Delivery.from_amqp_delivery(meta, payload)
    )

    {:noreply, {channel, receiver, consumer_tag}}
  end
end
