defmodule Coniglio.Service do
  @moduledoc """
    Coniglio.Service

    This module is used to register a service and a list of listeners
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec init([
          {:listeners, [Coniglio.Listener.t()]},
          {:timeout, Integer.t()},
          {:broker_url, String.t()}
        ]) :: {:ok, any}
  def init(listeners: listeners, timeout: timeout, broker_url: broker_url) do
    Supervisor.init(
      [{Coniglio.Client, [timeout: timeout, broker_url: broker_url]} | listeners],
      strategy: :one_for_one
    )
  end
end
