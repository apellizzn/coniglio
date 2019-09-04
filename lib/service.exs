defmodule Service do
  defstruct Name: nil
            BrokerUrl:   nil
            Rabbit:      nil
            listeners:   []

   @type t() :: %__MODULE__{
          Name: String.t(),
          Rabbit: integer(),
          listeners: String.t() | nil
        }

  def newService(opts) do
    %Service{
      Name:  opt.name,
      Rabbit: 1,
      listeners: []
    }
  end
end
