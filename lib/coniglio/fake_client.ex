defmodule Coniglio.FakeClient do
  use Coniglio.IClient

  defstruct [:broker_url, :connection, :channel, :timeout, consumers: []]

  def start_link(opts) do
    {:ok, %Coniglio.FakeClient{broker_url: opts[:broker_url], timeout: opts[:timeout]}}
  end

  def handle_call({:bind_exchange, prefix, exchange, topic}, _from, client) do
    {:reply, "#{prefix}-#{exchange}-#{topic}", client}
  end

  def handle_call(:get_client, _from, client) do
    {:reply, client, client}
  end

  def handle_call({:register_consumer, _queue, _opts}, _from, client) do
    {:reply, {:ok, "consumer-tag"},
     %Coniglio.FakeClient{client | consumers: ["consumer-tag" | client.consumers]}}
  end

  def handle_call({:request, _ctx, request}, _from, client) do
    {:reply, request.body, client}
  end

  def handle_cast({:publish, _ctx, _request}, client) do
    {:noreply, client}
  end
end
