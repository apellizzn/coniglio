defmodule SayHi do
  use Coniglio.Listener, exchange: "salutation", topic: "simple"

  def handle(delivery) do
    %Message{name: name} = Message.decode(delivery.body)
    Logger.info("Hi #{name}!")
    delivery.body
  end
end
