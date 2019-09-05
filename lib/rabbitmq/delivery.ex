defmodule Delivery do
  defstruct [:headers, :body, :exchange, :routing_key, :reply_to]

  def fromResponse(exchange, routing_key, response) do
    %Delivery{
      exchange: exchange,
      routing_key: routing_key,
      body: response.payload,
      headers: response.headers,
      reply_to: response.reply_to
    }
  end

  def fromAmqpDelivery(meta, payload) do
    %Delivery{
      headers: meta.headers,
      body: payload,
      exchange: meta.exchange,
      routing_key: meta.routing_key,
      reply_to: meta.reply_to
    }
  end
end
