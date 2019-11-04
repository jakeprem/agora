defmodule Agora.Schemas.Transaction do
  @attributes [:id, :buyer_id, :seller_id, :widget_id]

  defstruct @attributes

  alias Agora.IdService

  def attributes, do: @attributes

  def new(buyer_id, seller_id, widget_id) do
    %__MODULE__{
      id: IdService.generate_id(),
      buyer_id: buyer_id,
      seller_id: seller_id,
      widget_id: widget_id
    }
  end

  def to_record(%__MODULE__{} = schema) do
    {
      __MODULE__,
      schema.id,
      schema.buyer_id,
      schema.seller_id,
      schema.widget_id
    }
  end

  def from_record({__MODULE__, id, buyer_id, seller_id, widget_id}) do
    %__MODULE__{
      id: id,
      buyer_id: buyer_id,
      seller_id: seller_id,
      widget_id: widget_id
    }
  end
end
