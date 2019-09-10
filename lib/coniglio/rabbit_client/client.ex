defmodule Coniglio.RabbitClient do
  @moduledoc """
    Coniglio.RabbitClient
  """
  @behaviour Coniglio.Contracts.Client
  require Logger

  defstruct [:broker_url, :connection, :channel, :timeout, consumers: []]

  @direct_reply_to "amq.rabbitmq.reply-to"
  def new_client(broker_url, timeout) do
    %Coniglio.RabbitClient{broker_url: broker_url, timeout: timeout}
  end

  def connect(client) do
    Logger.info("Connecting to broker...")

    with {:ok, conn} <-
           AMQP.Connection.open([connection_timeout: client.timeout], client.broker_url),
         {:ok, chan} <- AMQP.Channel.open(conn) do
      Logger.info("Connection successful")
      %Coniglio.RabbitClient{client | connection: conn, channel: chan}
    else
      {:error, err} ->
        Logger.error(err)
        {:error, err}

      err ->
        Logger.error(err)
        {:error, err}
    end
  end

  def stop(client) do
    Logger.info("Stopping RabbitMQ client...")

    case AMQP.Connection.close(client.connection) do
      :ok ->
        Logger.info("RabbitMQ client stopped")
        :ok
      {:error, err} ->
        Logger.error(err)
        {:error, err}
    end
  end

  def cast(client, ctx, request) do
    do_publish(
      client,
      request.exchange,
      request.routing_key,
      ctx.correlation_id,
      request.headers,
      request.body,
      ctx.reply_to
    )
  end

  def bind_exchange(channel, prefix, exchange, topic) do
    queue = "#{prefix}-#{exchange}-#{topic}"
    Logger.info("Creating handler for queue #{queue}")

    with :ok <- AMQP.Exchange.topic(channel, exchange),
         {:ok, _} <- AMQP.Queue.declare(channel, queue, durable: false),
         :ok <- AMQP.Queue.bind(channel, queue, exchange, routing_key: topic) do
      {:ok, queue}
    else
      _ -> {:error, "Could not create the queue #{queue}"}
    end
  end

  @spec call(
          atom | %{channel: AMQP.Channel.t()},
          atom | %{correlation_id: binary},
          atom | %{body: binary, exchange: binary, headers: any, routing_key: binary}
        ) :: any
  def call(client, ctx, request) do
    consumer_id = UUID.uuid1()

    {:ok, _pid} =
      Coniglio.RabbitClient.DirectReceiver.start_link(
        receiver: self(),
        client: client,
        queue: @direct_reply_to,
        ctx: ctx,
        consumer_tag: consumer_id
      )

    do_publish(
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

  def listen(client, ctx, queue, options) do
    #Coniglio.RabbitClient.Server.start_link(options ++ [client: client, queue: queue, ctx: ctx])
  end

  @spec do_publish(
          Coniglio.RabbitClient.t(),
          String.t(),
          String.t(),
          String.t(),
          any,
          String.t(),
          String.t() | nil
        ) :: :ok | :error
  defp do_publish(client, exchange, routing_key, correlation_id, headers, body, reply_to) do
    IO.puts("publish to #{exchange}#{routing_key}")

    case AMQP.Basic.publish(client.channel, exchange, routing_key, body,
             headers: headers,
             persistent: true,
             reply_to: if(reply_to, do: reply_to, else: :undefined),
             timestamp: :os.system_time(:millisecond),
             content_type: "application/vnd.google.protobuf"
           ) do
      :ok -> :ok
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

  def add_consumer(client, consumer) do
    %Coniglio.RabbitClient{client | consumers: [consumer | client.consumers]}
  end
end
