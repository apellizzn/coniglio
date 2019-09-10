defmodule Coniglio.Service.Data do
  use Agent

  def start_link(data) do
    Agent.start_link(fn -> data end, name: __MODULE__)
  end

  def client do
    Agent.get(__MODULE__, fn state -> state end)
  end
end
