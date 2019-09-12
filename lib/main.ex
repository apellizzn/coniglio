defmodule Main do
  require Logger
  use Coniglio

  def try do
    Coniglio.Service.start_link(
      listeners: [SayHi],
      timeout: 1000
    )

    # Coniglio.RabbitClient.RealClient.publish(%Context{correlation_id: '123'}, %Delivery{
    #   exchange: "say_hi_exchange",
    #   routing_key: "say_hi_topic",
    #   body: Message.encode(Message.new(name: "Albe")),
    #   headers: []
    # })

    Coniglio.RabbitClient.RealClient.request(%Context{correlation_id: '123'}, %Delivery{
      exchange: "say_hi_exchange",
      routing_key: "say_hi_topic",
      body: Message.encode(Message.new(name: "Albe")),
      headers: []
    })
    |> (fn delivery -> delivery.body end).()
    |> Message.decode()
  end
end
