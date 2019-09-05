defmodule Context do
  @enforce_keys [:correlation_id]
  defstruct [:correlation_id, reply_to: :undefined]
end
