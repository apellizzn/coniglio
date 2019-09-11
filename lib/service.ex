defmodule Coniglio.Service do
  @client Application.get_env(:coniglio, :client)
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    Supervisor.init(
      [
        {@client, [broker_url: opts[:broker_url], timeout: opts[:timeout]]}
        | Enum.map(opts[:listeners], fn listener -> {Server, listener} end)
      ],
      strategy: :one_for_one
    )
  end
end
