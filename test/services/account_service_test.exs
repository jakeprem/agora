defmodule Agora.AccountServiceTest do
  use ExUnit.Case

  alias Agora.Schemas.Account
  alias Agora.AccountService

  setup_all do
    Agora.AccountRepo.init()
    :ok
  end

  setup do
    :mnesia.clear_table(:account)

    :ok
  end

  describe "User can create an account" do
    test "account can be created and read" do
      # The easiest way to prove the account was written is to read it out again
      assert {:ok, account} = AccountService.create("George", "Washington")

      %Account{id: id} = account

      assert {:ok, ^account} = AccountService.get(id)
    end
  end

  describe "Can add funds to account" do
    test "new balance = old balance + added amount" do
      {:ok, account} = AccountService.create("Jake", "Prem")
      assert %Account{balance: 0.0} = account

      {:ok, account} = AccountService.add_funds(account.id, 10.00)
      assert %Account{balance: 10.00} = account

      {:ok, account} = AccountService.add_funds(account.id, 10.00)
      assert %Account{balance: 20.00} = account
    end

    test "first name, last name, and id are unchanged" do
      {:ok, initial_account} = AccountService.create("Jake", "Prem")
      assert %Account{balance: 0.0} = initial_account

      {:ok, changed_account} = AccountService.add_funds(initial_account.id, 10.00)

      assert initial_account.id == changed_account.id
      assert initial_account.first_name == changed_account.first_name
      assert initial_account.last_name == changed_account.last_name
    end
  end

  # test "User can log in to account"
end
