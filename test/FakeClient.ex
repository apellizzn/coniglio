defmodule FakeClient do
  @behaviour Coniglio.Contracts.Client
  defstruct [:broker_url, :connection, :channel, :timeout, consumers: []]

  def new_client(broker_url, timeout) do
    %FakeClient{broker_url: broker_url, timeout: timeout}
  end

  def connect(client) do
    {:ok, %FakeClient{client | connection: "connected"}}
  end

  def stop(_client) do
  end

  def cast(_arg0, _arg1, _arg2) do
  end

  def call(_arg0, _arg1, _arg2) do
  end

  def add_consumer(_arg0, _arg1) do
  end

  def bind_exchange(_channel, prefix, exchange, topic) do
    {:ok, "#{prefix}-#{exchange}-#{topic}"}
  end

  def listen(_client, _ctx, _queue, _options) do
    {:ok, self()}
  end
end
