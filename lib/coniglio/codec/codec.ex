defmodule Coniglio.Codec do
  @moduledoc """
    Coniglio.Codec
  """
  @callback encode(any) :: byte()
  @callback decode(byte) :: any
  @callback mime_type() :: String.t()
end
