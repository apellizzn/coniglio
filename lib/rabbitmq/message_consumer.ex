defmodule MessageConsumer do
  use GenServer
  use AMQP
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, [])
  end

  def init(opts) do
    client = opts[:client]

    {:ok, _consumer_tag} =
      AMQP.Basic.consume(client.channel, opts[:queue], nil, consumer_tag: opts[:consumer_tag])

    {:ok, client}
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

  # def handle_info(
  #       {:basic_deliver, payload, meta},
  #       client
  #     ) do
  #   delivery = Delivery.fromAmqpDelivery(meta, payload)
  #   # result = handler.(delivery)

  #   if delivery.reply_to != :undefined do
  #     RabbitClient.cast(
  #       client,
  #       %Context{correlation_id: "123"},
  #       Delivery.fromResponse(exchange, delivery.reply_to, %{
  #         payload: Message.encode(result),
  #         headers: []
  #       })
  #     )
  #   end

  #   {:noreply, client}
  # end
end
