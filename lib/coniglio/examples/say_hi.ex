defmodule SayHi do
  use Coniglio.Listener

  def exchange do
    "say_hi_exchange"
  end

  def topic do
    "say_hi_topic"
  end

  def handle(delivery) do
    %Message{name: name} = Message.decode(delivery.body)
    Logger.info("Hi #{name}!")
    delivery.body
  end
end
