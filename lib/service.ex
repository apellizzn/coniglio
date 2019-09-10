defmodule Coniglio.Service do
  @moduledoc """
    Coniglio.Service
  """
  @enforce_keys [:rabbit]
  defstruct [:name, :timeout, :rabbit, listeners: []]

  require Logger
  use Coniglio

  @client Application.get_env(:coniglio, :client)
  @type service_opts :: [name: String.t(), timeout: Integer.t()]

  @type t() :: %__MODULE__{
          name: String.t(),
          rabbit: RabbitClient.t(),
          listeners: [Touple.t()]
        }

  @spec new_service(service_opts) :: Service.t()
  def new_service(opts) do
    %Service{
      name: opts[:name],
      timeout: opts[:timeout],
      rabbit: @client.new_client("amqp://localhost:5672", opts[:timeout])
    }
  end

  @spec start(Service.t()) :: Service.t()
  def start(service) do
    service
    |> connect_client
    |> start_listeners
  end


  defp connect_client(service) do
    %Service{service | rabbit: service.rabbit |> @client.connect() |> elem(1)}
  end

  defp start_listeners(service) do
    %Service{
      service |
      listeners: Enum.map(
        service.listeners,
        fn listener -> listener.(%Coniglio.Context{correlation_id: UUID.uuid1()}) end
      )
    }
  end

  @spec add_listener(Service.t(), String.t(), String.t(), MessageHandler.t()) ::
          :ok
          | {:error, any}
          | {:ok, pid}
  def add_listener(service, exchange, topic, handler) do
    %Service{
      service |
      listeners: [
        fn ctx ->
          case @client.bind_exchange(service.rabbit.channel, service.name, exchange, topic) do
            {:ok, queue} ->
              @client.listen(service.rabbit, ctx, queue, handler: handler)
            {:error, err} ->
                Logger.error(err)
                :error
          end
        end
        | service.listeners
      ]
    }
  end
end
