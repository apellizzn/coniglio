defmodule Message do
  @moduledoc """
    Message
  """
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          last_name: String.t(),
          age: Integer.t()
        }
  defstruct [:name, :last_name, :age]

  field(:name, 1, type: :string)
  field(:last_name, 2, type: :string)
  field(:age, 3, type: :int32)
end
