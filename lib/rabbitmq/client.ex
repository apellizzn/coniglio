defmodule RabbitClient do
  require Logger

  defstruct [:brokerUrl, :connection, :channel, :timeout, consumers: []]

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

  @spec cast(RabbitClient.t(), Context.t(), Delivery.t()) :: :ok | :error
  def cast(client, ctx, request) do
    doPublish(
      client,
      request.exchange,
      request.routing_key,
      ctx.correlation_id,
      request.headers,
      request.body,
      ctx.replyTo
    )
  end

  @spec listen(RabbitClient.t(), Context.t(), String.t(), [any()]) :: {:ok, pid()}
  def listen(client, ctx, queue, options) do
    {:ok, _} = MessageProcessor.start_link(options ++ [client: client, queue: queue, ctx: ctx])
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
    try do
      AMQP.Basic.publish(client.channel, exchange, routing_key, body,
        headers: headers,
        persistent: true,
        reply_to: if(reply_to, do: reply_to, else: :undefined),
        timestamp: :os.system_time(:millisecond),
        content_type: "application/vnd.google.protobuf"
      )

      :ok
    catch
      err ->
        Logger.error(%{
          error: err,
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
    %RabbitClient{client | consumers: [client.consumers | consumer]}
  end
end
