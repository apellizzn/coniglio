defmodule SayHi do
  use Coniglio.Listener

  def exchange do
    "salutation"
  end

  def topic do
    "simple"
  end

  def handle(delivery) do
    %Message{name: name} = Message.decode(delivery.body)
    Logger.info("Hi #{name}!")
    delivery.body
  end
end
