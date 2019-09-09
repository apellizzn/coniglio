defmodule FakeAmqp do
  defmodule Connection do
    def open(_, _) do
      {:ok, "fake_conn"}
    end

    def close(_) do
      :ok
    end
  end

  defmodule Channel do
    def open(_) do
      {:ok, "fake_chan"}
    end

    def close(_) do
      :ok
    end
  end
end
