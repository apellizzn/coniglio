defmodule Coniglio.ServiceTest do
  use ExUnit.Case, async: true

  defmodule Consume do
    @behaviour Coniglio.RabbitClient.MessageHandler
    def handle(delivery) do
      delivery
    end
  end

  describe "new_service" do
    test "returns a connected client" do
      service = Coniglio.Service.new_service(name: "foo", timeout: 1000)

      assert %{name: "foo", timeout: 1000, listeners: []} = service
    end
  end

  describe "start" do
    test "connect the client and start the listeners" do
      service = Coniglio.Service.new_service(name: "foo", timeout: 1000)
               |> Coniglio.Service.add_listener("exchange", "topic", Consume)
               |> Coniglio.Service.start()
      assert %{rabbit: %FakeClient{connection: "connected"}, listeners: [ok: _] } = service
    end
  end

  describe "add_listener" do
    test "add a listener" do
      %Coniglio.Service{ listeners: listeners } =
               Coniglio.Service.new_service(name: "foo", timeout: 1000)
               |> Coniglio.Service.start()
               |> Coniglio.Service.add_listener("exchange", "topic", Consume)
               |> Coniglio.Service.add_listener("exchange2", "topic2", Consume)
      assert Enum.count(listeners) == 2
    end
  end
end
