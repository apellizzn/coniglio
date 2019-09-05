defmodule Context do
  @enforce_keys [:correlation_id]
  defstruct [:correlation_id, :replyTo]
end
