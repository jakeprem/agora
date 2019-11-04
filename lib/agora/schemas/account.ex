defmodule Agora.Schemas.Account do
  @moduledoc """
  Struct for representing accounts in the system.
  """
  @attributes [:id, :first_name, :last_name, :balance]

  @derive Jason.Encoder
  defstruct @attributes

  alias Agora.IdService

  @doc """
  Make the attributes list available.

  Currently used to create the Mnesia table
  """
  def attributes, do: @attributes

  @doc """
  Creates a new Account struct. Can be persisted with `Agora.AccountRepo`.

  Defaults balance to 0.
  """
  @spec new(String.t(), String.t()) :: Agora.Schemas.Account.t()
  def new(first_name, last_name) do
    %__MODULE__{
      id: IdService.generate_id(),
      first_name: first_name,
      last_name: last_name,
      balance: 0.0
    }
  end

  @doc """
  Converts a `Agora.Schemas.Account` to a record to be inserted into :mnesia.

  This should only need to be used in `Agora.AccountRepo`
  """
  @spec to_record(Agora.Schemas.Account.t()) :: {Agora.Schemas.Account, any, any, any, any}
  def to_record(%__MODULE__{} = schema) do
    {
      __MODULE__,
      schema.id,
      schema.first_name,
      schema.last_name,
      schema.balance
    }
  end

  @doc """
  Converts an Account record to an `Agora.Schemas.Account` to be used by the rest of the app.

  This should only need to be used in `Agora.AccountRepo`
  """
  @spec from_record({Agora.Schemas.Account, any, any, any, any}) :: Agora.Schemas.Account.t()
  def from_record({__MODULE__, id, first_name, last_name, balance}) do
    %__MODULE__{
      id: id,
      first_name: first_name,
      last_name: last_name,
      balance: balance
    }
  end
end
