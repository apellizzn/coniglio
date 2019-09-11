defmodule SayHi do
  require Logger
  @behaviour Coniglio.Listener

  def exchange do
    "say_hi_exchange"
  end

  def topic do
    "say_hi_topic"
  end

  def handle(delivery) do
    Logger.info("#{__MODULE__} Received a message")
    %Message{name: name} = Message.decode(delivery.body)
    Logger.info("Hi #{name}!")
    delivery.body
  end
end
