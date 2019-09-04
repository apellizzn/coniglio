defmodule RabbitClient do
  require Logger
  defstruct [:brokerUrl, :connection, :channel, :timeout, consumers: []]

  def connect(client) do
    Logger.info("Connecting to broker...")

    with {:ok, conn} <-
           AMQP.Connection.open([connection_timeout: client.timeout], client.brokerUrl),
         {:ok, chan} <- AMQP.Channel.open(conn) do
      Logger.info("Connection successful")
      %RabbitClient{client | connection: conn, channel: chan}
    else
      {:error, err} -> Logger.error(err)
      _ -> Logger.error("Urecognized error")
    end
  end

  def stop(client) do
    Logger.info("Stopping RabbitMQ client...")

    with :ok <- AMQP.Channel.close(client.channel),
         :ok <-
           AMQP.Connection.close(client.connection) do
      Logger.info("RabbitMQ client stopped")
    else
      {:error, _} -> Logger.error("Connection teardown failed")
    end
  end
end
