defmodule Agora.AccountService do
  @moduledoc """
  Service for Account related features.
    - Create Account
    - Add funds to account
    - List ids of accounts in system
  """

  alias Agora.Schemas.Account
  alias Agora.Schemas.Widget

  alias Agora.AccountRepo
  alias Agora.WidgetRepo

  @doc """
  Create a new account in the system.
  """
  def create(first_name, last_name) do
    :mnesia.transaction(fn ->
      new_account = Account.new(first_name, last_name)

      with :ok <- AccountRepo.write(new_account) do
        new_account
      end
    end)
    |> convert_tuples()
  end

  @doc """
  Add funds to an account
  """
  def add_funds(account_id, funds_to_add) when is_number(funds_to_add) and funds_to_add > 0 do
    :mnesia.transaction(fn ->
      account = AccountRepo.read(account_id)

      if account == nil do
        :mnesia.abort("Account does not exist")
      end

      new_balance = account.balance + funds_to_add
      account_with_funds = %Account{account | balance: new_balance}

      with :ok <- AccountRepo.write(account_with_funds) do
        account_with_funds
      end
    end)
    |> convert_tuples()
  end

  def add_funds(_account_id, invalid_funds), do: {:error, "Invalid amount: #{invalid_funds}"}

  @doc """
  Retrieve an account by id
  """
  def get(id) do
    :mnesia.transaction(fn ->
      case AccountRepo.read(id) do
        nil -> :mnesia.abort("Account does not exist")
        other -> other
      end
    end)
    |> convert_tuples()
  end

  def get_widgets(account_id) do
    :mnesia.transaction(fn ->
      account = AccountRepo.read(account_id)
      if account == nil do
        :mnesia.abort("Account does not exist")
      end

      WidgetRepo.list_for_owner(account_id)
    end)
    |> convert_tuples()
  end

  @doc """
  List ids of all accounts in the system
  """
  def list_ids do
    :mnesia.transaction(fn ->
      AccountRepo.list_ids()
    end)
    |> convert_tuples()
  end

  defp convert_tuples(return_value) when is_tuple(return_value) do
    case return_value do
      {:atomic, val} -> {:ok, val}
      {:aborted, reason} -> {:error, reason}
    end
  end
end
