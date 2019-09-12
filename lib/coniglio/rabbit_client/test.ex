defmodule DirectReceiver do
  use GenServer
  use AMQP

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: String.to_atom(opts[:consumer_tag]))
  end

  def init(opts) do
    case AMQP.Basic.consume(opts[:channel], opts[:queue], self(),
           consumer_tag: opts[:consumer_tag],
           no_ack: true
         ) do
      {:ok, _} -> {:ok, nil}
      _ -> {:stop, "error"}
    end
  end

  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, _) do
    IO.puts("Basic consumer #{consumer_tag} registered")
    {:noreply, nil}
  end

  def handle_info(
        {:basic_deliver, payload, _meta},
        _
      ) do
    IO.inspect(payload.body)

    {:noreply, nil}
  end
end
