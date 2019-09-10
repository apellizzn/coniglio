defmodule Coniglio.Context do
  @moduledoc """
    Coniglio.Context
  """

  @enforce_keys [:correlation_id]
  defstruct [:correlation_id, reply_to: :undefined]

  def from_amqp_meta(meta) do
    %Coniglio.Context{
      correlation_id: meta.correlation_id,
      reply_to: meta.reply_to
    }
  end
end
