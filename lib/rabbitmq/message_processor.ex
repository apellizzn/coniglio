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
    IO.puts("consume #{opts[:queue]}")
    {:ok, consumer_tag} = Basic.consume(chan, opts[:queue])
    {:ok, {RabbitClient.add_consumer(client, consumer_tag), opts[:handler]}}
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
        {client, handler}
      ) do
    try do
      Basic.ack(client.channel, meta.delivery_tag)

      result =
        Delivery.fromAmqpDelivery(meta, payload)
        |> handler.()

      Context.fromAmqpMeta(meta) |> reply(client, result)

      {:noreply, {client, handler}}
    catch
      _ -> AMQP.Basic.nack(client.channel, meta.delivery_tag)
    end
  end

  @spec reply(Context.t(), RabbitClient.t(), any) :: nil
  def reply(%Context{reply_to: nil}, _, _) do
  end

  def reply(%Context{reply_to: :undefined}, _, _) do
  end

  def reply(ctx, client, result) do
    RabbitClient.cast(
      client,
      %Context{ctx | reply_to: :undefined},
      Delivery.fromResponse("", ctx.reply_to, %{payload: result, headers: []})
    )
  end
end
