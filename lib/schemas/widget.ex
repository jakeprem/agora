defmodule Agora.Schemas.Widget do
  @attributes [:id, :owner, :name, :description, :is_for_sale, :price]

  defstruct @attributes

  alias Agora.IdService

  def attributes, do: @attributes

  def new(owner, name, description, is_for_sale, price) do
    %__MODULE__{
      id: IdService.generate_id(),
      owner: owner,
      name: name,
      description: description,
      is_for_sale: is_for_sale,
      price: price
    }
  end

  def to_record(%__MODULE__{} = schema ) do
    {
      __MODULE__,
      schema.id,
      schema.owner,
      schema.name,
      schema.description,
      schema.is_for_sale,
      schema.price
    }
  end

  def from_record({__MODULE__, id, owner, name, description, is_for_sale, price}) do
    %__MODULE__{
      id: id,
      owner: owner,
      name: name,
      description: description,
      is_for_sale: is_for_sale,
      price: price
    }
  end
end
