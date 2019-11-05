defmodule Agora.Schemas.Transaction do
  @moduledoc """
  Struct for representing transactions in the system.
  """
  @attributes [:id, :buyer_id, :seller_id, :widget_id]

  @derive Jason.Encoder
  defstruct @attributes

  alias Agora.IdService

  @doc """
  Make the attributes list available.

  Currently used to create the Mnesia table
  """
  def attributes, do: @attributes

  @doc """
  Creates a new Transaction struct. Can be persisted with `Agora.TransactionRepo`.
  """
  @spec new(String.t(), String.t(), String.t()) :: Agora.Schemas.Transaction.t()
  def new(buyer_id, seller_id, widget_id) do
    %__MODULE__{
      id: IdService.generate_id(),
      buyer_id: buyer_id,
      seller_id: seller_id,
      widget_id: widget_id
    }
  end

  @doc """
  Converts a `Agora.Schemas.Transaction` to a record to be inserted into :mnesia.

  This should only need to be used in `Agora.TransactionRepo`
  """
  @spec to_record(Agora.Schemas.Transaction.t()) ::
          {Agora.Schemas.Transaction, any, any, any, any}
  def to_record(%__MODULE__{} = schema) do
    {
      __MODULE__,
      schema.id,
      schema.buyer_id,
      schema.seller_id,
      schema.widget_id
    }
  end

  @doc """
  Converts a Transaction record to a `Agora.Schemas.Transaction` to be used by the rest of the app.

  This should only need to be used in `Agora.TransactionRepo`
  """
  @spec from_record({Agora.Schemas.Transaction, any, any, any, any}) ::
          Agora.Schemas.Transaction.t() | nil
  def from_record({__MODULE__, id, buyer_id, seller_id, widget_id}) do
    %__MODULE__{
      id: id,
      buyer_id: buyer_id,
      seller_id: seller_id,
      widget_id: widget_id
    }
  end

  def from_record(nil), do: nil
end
