defmodule Main do
  require Logger
  use Coniglio

  def try do
    Service.start_link(
      listeners: [SayHi],
      timeout: 1000
    )

    RabbitClient.RealClient.request(%Context{correlation_id: '123'}, %Delivery{
      exchange: "say_hi_exchange",
      routing_key: "say_hi_topic",
      body: Message.encode(Message.new(name: "Albe")),
      headers: []
    })
    |> (fn delivery -> delivery.body end).()
    |> Message.decode()
  end
end
