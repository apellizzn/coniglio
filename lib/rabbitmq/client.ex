defmodule RabbitClient do
  require Logger

  defstruct [:brokerUrl, :connection, :channel, :timeout, consumers: []]

  defmodule Receiver do
    def wait_for_messages(client) do
      receive do
        {:basic_deliver, payload, meta} ->
          Delivery.fromAmqpDelivery(meta, payload)
          wait_for_messages(client)
        {:EXIT, _from, _reason} ->

      end
    end
  end

  @spec connect(RabbitClient.t()) :: RabbitClient.t() | :error
  def connect(client) do
    Logger.info("Connecting to broker...")

    with {:ok, conn} <-
           AMQP.Connection.open([connection_timeout: client.timeout], client.brokerUrl),
         {:ok, chan} <- AMQP.Channel.open(conn) do
      Logger.info("Connection successful")
      %RabbitClient{client | connection: conn, channel: chan}
    else
      {:error, err} ->
        Logger.error(err)
        :error

      _ ->
        Logger.error("Unrecognized error")
        :error
    end
  end

  @spec stop(RabbitClient.t()) :: :ok | :error
  def stop(client) do
    Logger.info("Stopping RabbitMQ client...")

    with :ok <- AMQP.Channel.close(client.channel),
         :ok <-
           AMQP.Connection.close(client.connection) do
      Logger.info("RabbitMQ client stopped")
      :ok
    else
      {:error, _} ->
        Logger.error("Connection teardown failed")
        :error
    end
  end

  @spec cast(RabbitClient.t(), Context.t(), Delivery.t()) :: nil
  def cast(client, ctx, request) do
    doPublish(
      client,
      request.exchange,
      request.routing_key,
      ctx.correlationId,
      request.headers,
      request.body,
      ctx.replyTo
    )
  end

  def listen(client, ctx, queue, auto_ack, exclusive, no_local, no_wait, args, handler) do
    with {:ok, consumer_tag} <-
           AMQP.Basic.consume(client.channel, queue,
             no_local: no_local,
             no_wait: no_wait,
             arguments: args,
             exclusive: exclusive,
             no_ack: !auto_ack
           ) do
              %RabbitClient{client | consumers: [client.consumers | consumer_tag]}
              |> Receiver.wait_for_messages()
           else
            error -> Logger.error(error)
           end
    end
  end

  @spec doPublish(
          RabbitClient.t(),
          String.t(),
          String.t(),
          String.t(),
          any,
          String.t(),
          String.t() | nil
        ) :: nil
  defp doPublish(client, exchange, routing_key, correlationId, headers, body, reply_to) do
    try do
      AMQP.Basic.publish(client.channel, exchange, routing_key, body,
        headers: headers,
        persistent: true,
        reply_to: if(reply_to, do: reply_to, else: :undefined),
        timestamp: Time.utc_now(),
        content_type: "application/vnd.google.protobuf"
      )

      nil
    catch
      err ->
        Logger.error(%{
          error: err,
          exchange: exchange,
          key: routing_key,
          body: body,
          correlationId: correlationId
        })

        nil
    end
  end
end
