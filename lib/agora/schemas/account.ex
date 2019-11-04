defmodule Agora.Schemas.Account do
  @attributes [:id, :first_name, :last_name, :balance]

  @derive Jason.Encoder
  defstruct @attributes

  alias Agora.IdService

  def attributes, do: @attributes

  def new(first_name, last_name) do
    %__MODULE__{
      id: IdService.generate_id(),
      first_name: first_name,
      last_name: last_name,
      balance: 0.0
    }
  end

  def to_record(%__MODULE__{} = schema) do
    {
      __MODULE__,
      schema.id,
      schema.first_name,
      schema.last_name,
      schema.balance
    }
  end

  def from_record({__MODULE__, id, first_name, last_name, balance}) do
    %__MODULE__{
      id: id,
      first_name: first_name,
      last_name: last_name,
      balance: balance
    }
  end
end
