defmodule Coniglio do
  use Application
  require Logger

  def start(_type, _args) do
    children = [Coniglio.Config]

    opts = [strategy: :one_for_one, name: Coniglio.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
