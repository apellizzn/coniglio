defmodule Coniglio.RabbitClientTest do
  use ExUnit.Case, async: true

  describe "connect" do
    test "returns a connected client" do
      client =
        %Coniglio.RabbitClient{brokerUrl: "foo", timeout: 1000}
        |> Coniglio.RabbitClient.connect()

      assert {:ok, %{connection: "fake_conn", channel: "fake_chan"}} = client
    end
  end

  describe "stop" do
    test "stop the client client" do
      {:ok, client} =
        %Coniglio.RabbitClient{brokerUrl: "foo", timeout: 1000}
        |> Coniglio.RabbitClient.connect()

      assert :ok === Coniglio.RabbitClient.stop(client)
    end
  end
end
