defmodule Agora.AccountRepoTest do
  use ExUnit.Case

  alias Agora.Schemas.Account
  alias Agora.AccountRepo

  setup_all do
    Agora.Setup.create_schema_and_start()

    :ok
  end

  setup do
    Agora.Setup.clear_tables()

    :ok
  end

  describe "write/1 and read/1" do
    test "writes and returns account with valid id" do
      new_account = Account.new("Jake", "Prem")

      :mnesia.transaction(fn ->
        AccountRepo.write(new_account)
      end)

      assert {:atomic, account} =
               :mnesia.transaction(fn ->
                 AccountRepo.read(new_account.id)
               end)

      assert account == new_account
    end

    test "read/1 returns nil when no account exists" do
      assert {:atomic, nil} =
               :mnesia.transaction(fn ->
                 AccountRepo.read("does_not_exist")
               end)
    end
  end

  describe "list_ids/0" do
    test "returns a list of the inserted ids" do
      a = Account.new("Bob", "Ross")
      b = Account.new("Frodo", "Shireson")

      :mnesia.transaction(fn ->
        AccountRepo.write(a)
        AccountRepo.write(b)
      end)

      assert {:atomic, ids} =
               :mnesia.transaction(fn ->
                 AccountRepo.list_ids()
               end)

      assert Enum.member?(ids, a.id)
      assert Enum.member?(ids, b.id)
    end
  end
end
