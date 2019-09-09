defmodule Coniglio.Context do
  @enforce_keys [:correlation_id]
  defstruct [:correlation_id, reply_to: :undefined]

  def fromAmqpMeta(meta) do
    %Coniglio.Context{
      correlation_id: meta.correlation_id,
      reply_to: meta.reply_to
    }
  end
end
