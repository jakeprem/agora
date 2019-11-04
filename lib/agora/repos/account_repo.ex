defmodule Agora.AccountRepo do
  alias Agora.Schemas.Account

  @tablename Account
  @attributes Account.attributes()

  def init do
    case :mnesia.create_table(@tablename,
           attributes: @attributes,
           disc_copies: [node()]
         ) do
      {:atomic, :ok} ->
        :ok

      {:aborted, {:already_exists, @tablename}} ->
        {:ok, "account table already created"}

      {:aborted, reason} ->
        {:error, reason}
    end
  end

  def write(%Account{} = account) do
    account
    |> Account.to_record()
    |> :mnesia.write()
  end

  def read(account_id) do
    {Account, account_id}
    |> :mnesia.read()
    |> List.first()
    |> Account.from_record()
  end

  def list_ids do
    :mnesia.all_keys(Account)
  end
end
