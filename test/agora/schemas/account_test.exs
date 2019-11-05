defmodule Agora.Schemas.AccountTest do
  use ExUnit.Case

  alias Agora.Schemas.Account

  describe "new/2" do
    test "Generates new Account with proper defaults" do
      assert %Account{
        first_name: "Jake",
        last_name: "Prem",
        balance: 0.0,
      } = Account.new("Jake", "Prem")
    end
  end

  describe "to_record/1" do
    test "converts schema to record" do
      schema = %Account{
        id: "someid",
        first_name: "J.R.R.",
        last_name: "Tolkien",
        balance: 0.0
      }

      assert {
        Account,
        schema.id,
        schema.first_name,
        schema.last_name,
        schema.balance
      } == Account.to_record(schema)
    end
  end

  describe "from_record/1" do
    test "converts record to schema" do
      schema = %Account{
        id: "someid",
        first_name: "J.R.R.",
        last_name: "Tolkien",
        balance: 0.0
      }

      assert schema == Account.from_record({
        Account,
        schema.id,
        schema.first_name,
        schema.last_name,
        schema.balance
      })
    end
  end

  test "to and from record test" do
    schema = %Account{
      id: "someid",
      first_name: "J.R.R.",
      last_name: "Tolkien",
      balance: 0.0
    }

    assert schema == schema |> Account.to_record() |> Account.from_record()
  end
end
