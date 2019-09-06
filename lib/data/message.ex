defmodule Message do
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          last_name: String.t()
        }
  defstruct [:name, :last_name]

  field(:name, 1, type: :string)
  field(:last_name, 1, type: :string)
end
