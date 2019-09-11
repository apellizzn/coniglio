defmodule Server do
  @behaviour Coniglio.Listener
  @client Application.get_env(:coniglio, :client)

  use GenServer
  use AMQP
  use Coniglio
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, [])
  end

  def init(listener) do
    client = @client.get()
    queue = @client.bind_exchange("", listener.exchange(), listener.topic())
    {:ok, _consumer_tag} = Basic.consume(client.channel, queue)
    {:ok, listener}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, state) do
    Logger.info("Server #{consumer_tag} registered")
    {:noreply, state}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, _}, state) do
    {:stop, :normal, state}
  end

  def handle_info(
        {:basic_deliver, payload, meta},
        listener
      ) do
    client = @client.get()

    try do
      Basic.ack(client.channel, meta.delivery_tag)

      result =
        Delivery.from_amqp_delivery(meta, payload)
        |> listener.handle()

      Context.from_amqp_meta(meta) |> reply(result)

      {:noreply, listener}
    catch
      _ -> AMQP.Basic.nack(client.channel, meta.delivery_tag)
    end
  end

  @spec reply(Context.t(), any) :: nil
  def reply(%Context{reply_to: nil}, _) do
  end

  def reply(%Context{reply_to: :undefined}, _) do
  end

  def reply(ctx, result) do
    Logger.info("Publish response to #{ctx.reply_to}")

    @client.publish(
      %Context{ctx | reply_to: :undefined},
      Delivery.from_response("", ctx.reply_to, %{payload: result, headers: []})
    )
  end
end
