defmodule RabbitClient do
  require Logger

  defstruct [:brokerUrl, :connection, :channel, :timeout, consumers: []]

  @direct_reply_to "amq.rabbitmq.reply-to"

  @spec connect(RabbitClient.t()) :: {:ok, RabbitClient.t()} | {:error, String.t()}
  def connect(client) do
    Logger.info("Connecting to broker...")

    with {:ok, conn} <-
           AMQP.Connection.open([connection_timeout: client.timeout], client.brokerUrl),
         {:ok, chan} <- AMQP.Channel.open(conn) do
      Logger.info("Connection successful")
      {:ok, %RabbitClient{client | connection: conn, channel: chan}}
    else
      {:error, err} ->
        Logger.error(err)
        {:error, err}

      _ ->
        Logger.error("Unrecognized error")
        {:error, "Unrecognized error"}
    end
  end

  @spec stop(RabbitClient.t()) :: :ok | {:error, String.t()}
  def stop(client) do
    Logger.info("Stopping RabbitMQ client...")

    with :ok <- AMQP.Connection.close(client.connection) do
      Logger.info("RabbitMQ client stopped")
      :ok
    else
      {:error, err} ->
        Logger.error(err)
        {:error, err}
    end
  end

  @spec cast(RabbitClient.t(), Context.t(), Delivery.t()) :: :ok | :error
  def cast(client, ctx, request) do
    doPublish(
      client,
      request.exchange,
      request.routing_key,
      ctx.correlation_id,
      request.headers,
      request.body,
      ctx.reply_to
    )
  end

  def call(client, ctx, request) do
    consumer_id = UUID.uuid1()

    {:ok, _pid} =
      MessageConsumer.start_link(
        receiver: self(),
        client: client,
        queue: @direct_reply_to,
        ctx: ctx,
        consumer_tag: consumer_id
      )

    doPublish(
      client,
      request.exchange,
      request.routing_key,
      ctx.correlation_id,
      request.headers,
      request.body,
      @direct_reply_to
    )

    receive do
      {:ok, deliver} -> deliver
    end
  end

  @spec listen(RabbitClient.t(), Context.t(), String.t(), [any()]) ::
          {:ok, pid()} | {:error, binary()}
  def listen(client, ctx, queue, options) do
    MessageProcessor.start_link(options ++ [client: client, queue: queue, ctx: ctx])
  end

  @spec doPublish(
          RabbitClient.t(),
          String.t(),
          String.t(),
          String.t(),
          any,
          String.t(),
          String.t() | nil
        ) :: :ok | :error
  defp doPublish(client, exchange, routing_key, correlation_id, headers, body, reply_to) do
    IO.puts("publish to #{exchange}#{routing_key}")

    with :ok <-
           AMQP.Basic.publish(client.channel, exchange, routing_key, body,
             headers: headers,
             persistent: true,
             reply_to: if(reply_to, do: reply_to, else: :undefined),
             timestamp: :os.system_time(:millisecond),
             content_type: "application/vnd.google.protobuf"
           ) do
      :ok
    else
      {:error, reason} ->
        Logger.error(%{
          error: reason,
          exchange: exchange,
          key: routing_key,
          body: body,
          correlation_id: correlation_id
        })

        :error
    end
  end

  @spec add_consumer(RabbitClient.t(), any) :: RabbitClient.t()
  def add_consumer(client, consumer) do
    %RabbitClient{client | consumers: [consumer | client.consumers]}
  end
end
