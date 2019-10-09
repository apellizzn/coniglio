defmodule Coniglio.ServiceIntegrationTest do
  use ExUnit.Case, async: true

  defmodule AddLastName do
    use Coniglio.Listener,
      exchange: "add-last-name-exchange",
      topic: "add-last-name-topic"

    def handle(delivery) do
      %Message{Message.decode(delivery.body) | last_name: "Pell"}
      |> Message.encode()
    end
  end

  defmodule AddAge do
    use Coniglio.Listener,
      exchange: "add-age-exchange",
      topic: "add-age-topic"

    def handle(delivery) do
      %Message{Message.decode(delivery.body) | age: 42}
      |> Message.encode()
    end
  end

  setup_all do
    Coniglio.Service.start_link(
      listeners: [AddLastName, AddAge],
      timeout: 1000,
      broker_url: Application.get_env(:coniglio, :broker_url)
    )

    :ok
  end

  describe "request" do
    test "returns the delivery" do
      delivery =
        Coniglio.Client.request(
          %Coniglio.Context{correlation_id: '123'},
          %Coniglio.Delivery{
            exchange: "add-last-name-exchange",
            routing_key: "add-last-name-topic",
            body: Message.encode(Message.new(name: "Albe")),
            headers: []
          }
        )

      assert Message.new(name: "Albe", last_name: "Pell") ==
               delivery.body
               |> Message.decode()

      delivery =
        Coniglio.Client.request(
          %Coniglio.Context{correlation_id: '123'},
          %Coniglio.Delivery{
            exchange: "add-age-exchange",
            routing_key: "add-age-topic",
            body: Message.encode(Message.new(name: "Albe")),
            headers: []
          }
        )

      assert Message.new(name: "Albe", age: 42) ==
               delivery.body
               |> Message.decode()

      Coniglio.Client.stop()
    end
  end
end
