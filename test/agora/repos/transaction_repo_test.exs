defmodule Agora.TransactionRepoTest do
  use ExUnit.Case

  alias Agora.Schemas.Transaction
  alias Agora.TransactionRepo

  setup_all do
    Agora.Setup.create_schema_and_start()

    :ok
  end

  setup do
    Agora.Setup.clear_tables()

    :ok
  end

  describe "write/1 and read/1" do
    test "writes and returns transaction with valid id" do
      new_transaction = Transaction.new("a_buyer_id", "a_seller_id", "a_widget_id")

      :mnesia.transaction(fn ->
        TransactionRepo.write(new_transaction)
      end)

      assert {:atomic, transaction} =
               :mnesia.transaction(fn ->
                 TransactionRepo.read(new_transaction.id)
               end)

      assert transaction == new_transaction
    end

    test "read/1 returns nil when transaction does not exist" do
      assert {:atomic, nil} =
               :mnesia.transaction(fn ->
                 TransactionRepo.read("does_not_exist")
               end)
    end
  end

  describe "list_ids/0" do
    test "returns a list of the inserted ids" do
      a = Transaction.new("a", "b", "c")
      b = Transaction.new("1", "2", "3")

      :mnesia.transaction(fn ->
        TransactionRepo.write(a)
        TransactionRepo.write(b)
      end)

      assert {:atomic, ids} =
               :mnesia.transaction(fn ->
                 TransactionRepo.list_ids()
               end)

      assert length(ids) == 2
      assert Enum.member?(ids, a.id)
      assert Enum.member?(ids, b.id)
    end
  end
end
