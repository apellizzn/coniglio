defmodule Coniglio.Delivery do
  @moduledoc """
    Coniglio.Delivery

    This module rappresent the message processed by Coniglio.Listener.t()
  """

  defstruct [:headers, :body, :exchange, :routing_key, :reply_to]

  @doc """
    Builds a Coniglio.Delivery.t() from a Rabbitmq response
  """
  @spec from_response(any, any, atom | %{headers: any, payload: any}) :: Coniglio.Delivery.t()
  def from_response(exchange, routing_key, response) do
    %Coniglio.Delivery{
      exchange: exchange,
      routing_key: routing_key,
      body: response.payload,
      headers: response.headers
    }
  end

  @doc """
    Builds a Coniglio.Delivery.t() from an amqp delivery
  """
  @spec from_amqp_delivery(%{exchange: String.t(), headers: any, routing_key: String.t()}, any) ::
          Coniglio.Delivery.t()
  def from_amqp_delivery(meta, payload) do
    %Coniglio.Delivery{
      headers: meta.headers,
      body: payload,
      exchange: meta.exchange,
      routing_key: meta.routing_key
    }
  end
end
