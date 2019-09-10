defmodule Coniglio.RabbitClient.Delivery do
  @moduledoc """
    Coniglio.RabbitClient.Delivery
  """

  defstruct [:headers, :body, :exchange, :routing_key, :reply_to]

  def from_response(exchange, routing_key, response) do
    %Coniglio.RabbitClient.Delivery{
      exchange: exchange,
      routing_key: routing_key,
      body: response.payload,
      headers: response.headers
    }
  end

  def from_amqp_delivery(meta, payload) do
    %Coniglio.RabbitClient.Delivery{
      headers: meta.headers,
      body: payload,
      exchange: meta.exchange,
      routing_key: meta.routing_key
    }
  end
end
