defmodule Coniglio.ServiceIntegrationTest do
  use ExUnit.Case, async: true

  defmodule AddLastName do
    @behaviour Coniglio.Listener
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
    @behaviour Coniglio.Listener
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
    Coniglio.Service.start_link(
      listeners: [AddLastName, AddAge],
      broker_url: "amqp://localhost:5672",
      timeout: 1000
    )

    :ok
  end

  describe "request" do
    test "returns the delivery" do
      delivery =
        Coniglio.RabbitClient.RealClient.request(
          %Coniglio.Context{correlation_id: '123'},
          %Coniglio.RabbitClient.Delivery{
            exchange: "add-last-name-exchange",
            routing_key: "add-last-name-topic",
            body: Message.encode(Message.new(name: "Albe")),
            headers: []
          }
        )

      assert Message.new(name: "Albe", last_name: "Pell") ==
               delivery.body
               |> Message.decode()
    end
  end
end