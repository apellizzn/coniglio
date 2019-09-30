defmodule Coniglio.Listener do
  defmacro __using__(_opts) do
    quote do
      use GenServer
      require Logger

      @callback exchange() :: String.t()
      @callback topic() :: String.t()
      @callback handle(Delivery.t()) :: byte()

      def start_link(opts) do
        GenServer.start_link(__MODULE__, opts, [])
      end

      def init(_opts) do
        queue = Coniglio.Client.bind_exchange("", exchange(), topic())

        case Coniglio.Client.register_consumer(queue) do
          {:ok, _} ->
            {:ok, nil}

          {:error, reason} ->
            {:stop, reason}
        end
      end

      def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, nil) do
        Logger.info("Server #{consumer_tag} registered")
        {:noreply, nil}
      end

      # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
      def handle_info({:basic_cancel, _}, nil) do
        {:stop, :normal, nil}
      end

      def handle_info({:basic_deliver, payload, meta}, nil) do
        client = Coniglio.Client.get()

        try do
          AMQP.Basic.ack(client.channel, meta.delivery_tag)

          result =
            Coniglio.Delivery.from_amqp_delivery(meta, payload)
            |> handle()

          Coniglio.Context.from_amqp_meta(meta) |> reply(result)

          {:noreply, nil}
        catch
          _ -> AMQP.Basic.nack(client.channel, meta.delivery_tag)
        end
      end

      @spec reply(Context.t(), any) :: nil
      def reply(%Coniglio.Context{reply_to: nil}, _) do
      end

      def reply(%Coniglio.Context{reply_to: :undefined}, _) do
      end

      def reply(ctx, result) do
        Logger.info("Publish response to #{ctx.reply_to}")

        Coniglio.Client.publish(
          %Coniglio.Context{ctx | reply_to: nil},
          Coniglio.Delivery.from_response("", ctx.reply_to, %{
            payload: result,
            headers: []
          })
        )
      end
    end
  end
end
