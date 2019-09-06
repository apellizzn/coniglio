defmodule MessageProcessor do
  use GenServer
  use AMQP
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, [])
  end

  def init(opts) do
    client = opts[:client]
    chan = opts[:client].channel

    # Register the GenServer process as a consumer
    {:ok, consumer_tag} = Basic.consume(chan, opts[:queue])
    {:ok, {RabbitClient.add_consumer(client, consumer_tag), opts[:exchange], opts[:handler]}}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, state) do
    Logger.info("Conusumer #{consumer_tag} registered")
    {:noreply, state}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, state) do
    Logger.info("Consumer #{consumer_tag} cancelled")
    {:stop, :normal, state}
  end

  def handle_info(
        {:basic_deliver, payload, meta},
        {client, exchange, handler} = state
      ) do
    delivery = Delivery.fromAmqpDelivery(meta, payload)
    result = handler.(delivery)
    Basic.ack(client.channel, meta[:delivery_tag])

    reply(delivery.reply_to, client, exchange, result)
    {:noreply, state}
  end

  def reply(nil, _, _, _) do
  end

  def reply(queue, client, exchange, result) do
    RabbitClient.cast(
      client,
      %Context{correlation_id: "123"},
      Delivery.fromResponse(exchange, queue, %{payload: result, headers: []})
    )
  end
end
