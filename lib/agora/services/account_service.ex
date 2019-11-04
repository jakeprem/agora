defmodule Agora.AccountService do
  @moduledoc """
  Service for creating a user account.
  """

  alias Agora.Schemas.Account
  alias Agora.AccountRepo

  def create(first_name, last_name) do
    :mnesia.transaction(fn ->
      new_account = Account.new(first_name, last_name)

      with :ok <- AccountRepo.write(new_account) do
        new_account
      end
    end)
    |> convert_tuples()
  end

  def add_funds(account_id, funds_to_add) when is_number(funds_to_add) do
    :mnesia.transaction(fn ->
      account = AccountRepo.read(account_id)

      new_balance = account.balance + funds_to_add
      account_with_funds = %Account{account | balance: new_balance}

      with :ok <- AccountRepo.write(account_with_funds) do
        account_with_funds
      end
    end)
    |> convert_tuples()
  end

  def get(id) do
    :mnesia.transaction(fn ->
      AccountRepo.read(id)
    end)
    |> convert_tuples()
  end

  def list_ids do
    :mnesia.transaction(fn ->
      AccountRepo.list_ids()
    end)
    |> convert_tuples()
  end

  defp convert_tuples(return_value) when is_tuple(return_value) do
    case return_value do
      {:atomic, val} -> {:ok, val}
      other -> {:error, other}
    end
  end
end
