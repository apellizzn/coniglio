defmodule Coniglio.RabbitClient.RealClient do
  use Coniglio.RabbitClient.Client
  use Coniglio
  require Logger

  @broker_url Application.get_env(:coniglio, :broker_url)
  @direct_reply_to "amq.rabbitmq.reply-to"

  defstruct [:broker_url, :connection, :channel, :timeout, consumers: []]

  def init(opts) do
    Logger.info("Connecting to broker...")

    with {:ok, conn} <-
           AMQP.Connection.open(
             @broker_url,
             connection_timeout: opts[:timeout]
           ),
         {:ok, chan} <- AMQP.Channel.open(conn) do
      Logger.info("Connection successful")

      {
        :ok,
        %RabbitClient.RealClient{
          broker_url: @broker_url,
          timeout: opts[:timeout],
          connection: conn,
          channel: chan
        }
      }
    else
      {:error, {{reason, _}, _}} ->
        Logger.error(reason)
        {:stop, reason}

      {:error, reason} ->
        Logger.error(reason)
        {:stop, reason}
    end
  end

  def handle_call({:bind_exchange, prefix, exchange, topic}, _from, client) do
    queue = "#{prefix}-#{exchange}-#{topic}"
    Logger.info("Creating handler for queue #{queue}")

    with :ok <- AMQP.Exchange.topic(client.channel, exchange),
         {:ok, _} <- AMQP.Queue.declare(client.channel, queue, durable: false),
         :ok <- AMQP.Queue.bind(client.channel, queue, exchange, routing_key: topic) do
      {:reply, queue, client}
    else
      _ -> {:stop, "Could not create the queue #{queue}"}
    end
  end

  def handle_call(:get_client, _from, client) do
    {:reply, client, client}
  end

  def handle_call({:register_consumer, queue, opts}, {from, _ref}, client) do
    case AMQP.Basic.consume(client.channel, queue, from, opts) do
      {:ok, consumer_tag} ->
        {
          :reply,
          {:ok, consumer_tag},
          %RabbitClient.RealClient{
            client
            | consumers: [consumer_tag | client.consumers]
          }
        }

      {:error, reason} ->
        {:stop, reason}
    end
  end

  def handle_call({:request, ctx, request}, from, client) do
    with {:ok, _pid} <-
           RabbitClient.DirectReceiver.start_link(
             channel: client.channel,
             receiver: from,
             queue: @direct_reply_to,
             ctx: ctx,
             consumer_tag: UUID.uuid1()
           ),
         {:ok, client} <-
           do_publish(
             client,
             request.exchange,
             request.routing_key,
             ctx.correlation_id,
             request.headers,
             request.body,
             @direct_reply_to
           ) do
      {:noreply, client}
    else
      {:error, reason} ->
        {:stop, reason}
    end
  end

  def handle_cast({:publish, ctx, request}, client) do
    case do_publish(
           client,
           request.exchange,
           request.routing_key,
           ctx.correlation_id,
           request.headers,
           request.body,
           nil
         ) do
      {:ok, client} -> {:noreply, client}
      {:error, reason} -> {:stop, reason}
    end
  end

  def handle_cast(:stop, client) do
    Logger.info("Stopping RabbitMQ client...")

    case AMQP.Connection.close(client.connection) do
      :ok ->
        Logger.info("RabbitMQ client stopped")
        {:noreply, client}

      {:error, err} ->
        Logger.error(err)
        throw(err)
    end
  end

  @spec do_publish(
          RabbitClient.RealClient.t(),
          String.t(),
          String.t(),
          String.t(),
          any,
          String.t(),
          String.t() | nil
        ) :: {:ok, RabbitClient.RealClient.t()} | {:error, :blocked | :closing}

  defp do_publish(client, exchange, routing_key, _correlation_id, headers, body, reply_to) do
    Logger.info("Publish message to #{exchange}#{routing_key}")

    case AMQP.Basic.publish(client.channel, exchange, routing_key, body,
           headers: headers,
           persistent: true,
           reply_to: if(reply_to, do: reply_to, else: :undefined),
           timestamp: :os.system_time(:millisecond),
           content_type: "application/vnd.google.protobuf"
         ) do
      :ok ->
        {:ok, client}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
