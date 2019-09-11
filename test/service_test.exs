defmodule Coniglio.ServiceTest do
  use ExUnit.Case, async: true

  defmodule Consume do
    @behaviour Coniglio.Listener
    def handle(delivery) do
      delivery
    end

    def exchange() do
      "test-exchange"
    end

    def topic() do
      "test-topic"
    end
  end

  describe "init" do
    test "start the service" do
      assert {:ok, pid} =
               Coniglio.Service.start_link(broker_url: "foo", timeout: 1000, listeners: [Consume])
    end
  end
end
