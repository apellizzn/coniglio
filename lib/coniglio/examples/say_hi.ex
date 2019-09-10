defmodule SayHi do
  @behaviour Coniglio.Listener

  def exchange do
    "say_hi_exchange"
  end

  def topic do
    "say_hi_topic"
  end

  def handle(delivery) do
    IO.puts("Received a message")
    %Message{ name: name} = Message.decode(delivery.body)
    IO.puts("Hi #{name}!")
  end
end
