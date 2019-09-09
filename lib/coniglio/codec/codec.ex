defmodule Coniglio.Codec do
  @callback encode(any) :: byte()
  @callback decode(byte) :: any
  @callback mime_type() :: String.t()
end
