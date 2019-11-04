defmodule Agora.TransactionRepo do
  alias Agora.Schemas.Transaction

  @tablename Transaction
  @attributes Transaction.attributes()

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

  def write(%Transaction{} = transaction) do
    transaction
    |> Transaction.to_record()
    |> :mnesia.write()
  end

  def read(transaction_id) do
    {Transaction, transaction_id}
    |> :mnesia.read()
    |> List.first()
    |> Transaction.from_record()
  end
end
