defmodule Coniglio.Config do
  @moduledoc """
    Coniglio.Config

    This module provide an easy way to fetch config from consul or your local env
  """
  use Agent
  alias Consul.HTTP.Raw, as: Consul

  @consul_url Application.get_env(:consul, :base_url)
  @consul_key Application.get_env(:consul, :key)

  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(_opts) do
    if @consul_url && @consul_key do
      with %{body: body, status_code: 200} <- Consul.kv_get(@consul_key) do
        Agent.start_link(fn -> consul_config(body) end, name: __MODULE__)
      else
        _ -> Agent.start_link(&Map.new/0, name: __MODULE__)
      end
    else
      Agent.start_link(&Map.new/0, name: __MODULE__)
    end
  end

  defp consul_config(body) do
    body
    |> Enum.at(0)
    |> Map.get("Value")
  end

  @spec get(key: String.t()) :: String.t()
  def get(key) do
    from_consul(key) || from_env(key)
  end

  defp from_consul(key) do
    path = String.split(key, ".")
    Agent.get(__MODULE__, fn config -> get_in(config, path) end)
  end

  defp from_env(key) do
    key
    |> String.split(".")
    |> Enum.map(&String.upcase/1)
    |> Enum.join("_")
    |> System.get_env()
  end
end
