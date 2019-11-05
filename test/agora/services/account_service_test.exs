defmodule Agora.AccountServiceTest do
  use ExUnit.Case

  alias Agora.Schemas.Account
  alias Agora.AccountService

  setup_all do
    Agora.Setup.create_schema_and_start()

    :ok
  end

  setup do
    Agora.Setup.clear_tables()

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

    test "cannot add funds to invalid account" do
      assert {:error, reason} = AccountService.add_funds("invalid_id", 1_000.0)
      assert reason =~ "Account"
    end

    test "added funds must be a number greater than 0" do
      assert {:error, reason} = AccountService.add_funds("unguarded_here", "dog")
      assert reason =~ "amount"
    end
  end

  describe "get/1" do
    test "successfully retrieves account" do
      {:ok, inserted_account} = AccountService.create("George", "Washington")

      assert {:ok, retrieved_account} = AccountService.get(inserted_account.id)
      assert inserted_account == retrieved_account
    end

    test "returns error when given an invalid id" do
      assert {:error, reason} = AccountService.get("blah")
      # assert reason =~ "something"
    end
  end

  test "list_ids works" do
    {:ok, %{id: id_a}} = AccountService.create("George", "Washington")
    {:ok, %{id: id_b}} = AccountService.create("Abe", "Lincoln")

    {:ok, ids} = AccountService.list_ids()

    assert length(ids) == 2
    assert Enum.member?(ids, id_a)
    assert Enum.member?(ids, id_b)
  end
end
