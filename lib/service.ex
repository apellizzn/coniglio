defmodule Service do
  defstruct [:name, :rabbit, :timeout, listeners: []]
  require Logger

  @type t() :: %__MODULE__{
          name: String.t(),
          rabbit: RabbitClient.t(),
          listeners: [String.t()] | []
        }

  def new_service(opts) do
    %Service{
      name: opts[:name],
      timeout: opts[:timeout],
      rabbit:
        %RabbitClient{brokerUrl: "amqp://localhost:5672", timeout: opts[:timeout]}
        |> RabbitClient.connect()
    }
  end

  def add_listener(service, exchange, topic, handler) do
    queue = "#{service.name}-#{exchange}-#{topic}"
    Logger.info("Creating handler for queue #{queue}")

    with :ok <- AMQP.Exchange.topic(service.rabbit.channel, exchange),
         {:ok, _} <- AMQP.Queue.declare(service.rabbit.channel, queue, durable: false),
         :ok <- AMQP.Queue.bind(service.rabbit.channel, queue, exchange, routing_key: topic) do
      RabbitClient.listen(service.rabbit, %Context{correlation_id: "123"}, queue, handler: handler)
    else
      _ -> Logger.error("Could not create the queue #{queue}")
    end
  end
end
