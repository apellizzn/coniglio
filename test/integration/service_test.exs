defmodule Coniglio.ServiceIntegrationTest do
  use ExUnit.Case, async: true
  use Coniglio

  defmodule AddLastName do
    use Coniglio.Listener

    def handle(delivery) do
      %Message{Message.decode(delivery.body) | last_name: "Pell"}
      |> Message.encode()
    end

    def exchange() do
      "add-last-name-exchange"
    end

    def topic() do
      "add-last-name-topic"
    end
  end

  defmodule AddAge do
    use Coniglio.Listener

    def handle(delivery) do
      %Message{Message.decode(delivery.body) | age: 42}
      |> Message.encode()
    end

    def exchange() do
      "add-age-exchange"
    end

    def topic() do
      "add-age-topic"
    end
  end

  setup_all do
    Coniglio.Service.start_link(listeners: [AddLastName, AddAge], timeout: 1000)
    :ok
  end

  describe "request" do
    test "returns the delivery" do
      delivery =
        RabbitClient.RealClient.request(
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
        RabbitClient.RealClient.request(
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

      RabbitClient.RealClient.stop()
    end
  end
end
