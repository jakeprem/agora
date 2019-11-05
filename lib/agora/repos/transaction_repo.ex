defmodule Agora.TransactionRepo do
  @moduledoc """
  Abstracts interacting with `Agora.Schemas.Transaction` records in the Mnesia database.

  `init/0` is called as part of `Agora.Setup.setup/0` and must be run to create the table before it can be used. You can run `mix db.setup` to setup the schema and all the tables.

  `write/1` and `read/1` must be called from within an `:mnesia.transaction`
  """
  alias Agora.Schemas.Transaction

  @tablename Transaction
  @attributes Transaction.attributes()

  @doc """
  Creates the Transaction table in :mnesia. The schema must be created before this command can be run.

  Running `mix db.setup` will do all of the database setup needed.
  """
  @spec init :: :ok | {:error, any} | {:ok, String.t()}
  def init do
    case :mnesia.create_table(@tablename,
           attributes: @attributes,
           disc_copies: [node()]
         ) do
      {:atomic, :ok} ->
        :ok

      {:aborted, {:already_exists, @tablename}} ->
        {:ok, "transaction table already created"}

      {:aborted, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Writes the given record to the Transaction table.

  Must be called from within an `:mnesia.transaction`.
  """
  @spec write(Agora.Schemas.Transaction.t()) :: :ok
  def write(%Transaction{} = transaction) do
    transaction
    |> Transaction.to_record()
    |> :mnesia.write()
  end

  @doc """
  Reads the record with the given `transaction_id` from the Transaction table.

  Must be called from within an `:mnesia.transaction`.
  """
  @spec read(String.t()) :: Agora.Schemas.Transaction.t()
  def read(transaction_id) do
    {@tablename, transaction_id}
    |> :mnesia.read()
    |> List.first()
    |> Transaction.from_record()
  end

  @doc """
  Returns a list of ids for all accounts in the table.

  Must be called from within an `:mnesia.transaction`
  """
  @spec list_ids :: [String.t()]
  def list_ids do
    :mnesia.all_keys(@tablename)
  end
end
