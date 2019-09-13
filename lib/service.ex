defmodule Coniglio.Service do
  @moduledoc """
    Coniglio.Service

    This module is used to register a service and a list of listeners
  """
  @client Application.get_env(:coniglio, :client)
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec init([
          {:listeners, [Coniglio.Listener.t()]},
          {:timeout, Integer.t()}
        ]) :: {:ok, any}
  def init(listeners: listeners, timeout: timeout) do
    Supervisor.init(
      [{@client, timeout: timeout} | listeners],
      strategy: :one_for_one
    )
  end
end
