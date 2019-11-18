defmodule Agora.Schemas.Widget do
  @moduledoc """
  Struct for representing transactions in the system.
  """
  @attributes [:id, :owner, :name, :description, :is_for_sale, :price]

  @derive Jason.Encoder
  defstruct @attributes

  alias Agora.IdService

  @doc """
  Make the attributes list available.

  Currently used to create the Mnesia table
  """
  def attributes, do: @attributes
  def update_channel, do: Atom.to_string(__MODULE__)

  @doc """
  Creates a new Widget struct. Can be persisted with `Agora.WidgetRepo`.
  """
  @spec new(String.t(), String.t(), String.t(), bool, number) :: Agora.Schemas.Widget.t()
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

  @doc """
  Converts a `Agora.Schemas.Widget` to a record to be inserted into :mnesia.

  This should only need to be used in `Agora.WidgetRepo`
  """
  @spec to_record(Agora.Schemas.Widget.t()) ::
          {Agora.Schemas.Widget, any, any, any, any, any, any}
  def to_record(%__MODULE__{} = schema) do
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

  @doc """
  Converts a Widget record to a `Agora.Schemas.Widget` to be used by the rest of the app.

  This should only need to be used in `Agora.WidgetRepo`
  """
  @spec from_record({Agora.Schemas.Widget, any, any, any, any, any, any}) ::
          Agora.Schemas.Widget.t() | nil
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

  def from_record(nil), do: nil

  def query(opts \\ []) do
    [__MODULE__|Enum.map(@attributes, &Keyword.get(opts, &1, :_))]
    |> List.to_tuple()
    |> :mnesia.match_object()
  end
end
