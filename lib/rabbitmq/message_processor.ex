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
    setup_queue(opts)

    # Register the GenServer process as a consumer
    {:ok, consumer_tag} = Basic.consume(chan, opts[:queue])
    {:ok, RabbitClient.add_consumer(client, consumer_tag)}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, chan) do
    Logger.info("Conusumer #{consumer_tag} registered")
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan) do
    Logger.info("Consumer #{consumer_tag} cancelled")
    {:stop, :normal, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    consume(chan, tag, redelivered, payload)
    {:noreply, chan}
  end

  defp setup_queue(opts) do
    chan = opts[:client].channel
    {:ok, _} = Queue.declare(chan, opts[:queue], durable: true)

    :ok = Exchange.fanout(chan, opts[:exchange], durable: true)
    :ok = Queue.bind(chan, opts[:queue], opts[:exchange])
  end

  defp consume(_, _, _, payload) do
    Logger.info("Received a message")
    IO.inspect(Message.decode(payload))
  end
end
