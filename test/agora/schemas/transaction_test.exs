defmodule Agora.Schemas.TransactionTest do
  use ExUnit.Case

  alias Agora.Schemas.Transaction

  describe "new/2" do
    test "Generates new Transaction with proper defaults" do
      transaction = %Transaction{
        buyer_id: "buyer_id",
        seller_id: "seller_id",
        widget_id: "widget_id"
      }

      assert transaction = Transaction.new(transaction.buyer_id, transaction.seller_id, transaction.widget_id)
    end
  end

  describe "to_record/1" do
    test "converts schema to record" do
      schema = %Transaction{
        buyer_id: "buyer_id",
        seller_id: "seller_id",
        widget_id: "widget_id"
      }

      assert {
        Transaction,
        schema.id,
        schema.buyer_id,
        schema.seller_id,
        schema.widget_id
      } == Transaction.to_record(schema)
    end
  end

  describe "from_record/1" do
    test "converts record to schema" do
      schema = %Transaction{
        buyer_id: "buyer_id",
        seller_id: "seller_id",
        widget_id: "widget_id"
      }

      assert schema == Transaction.from_record({
        Transaction,
        schema.id,
        schema.buyer_id,
        schema.seller_id,
        schema.widget_id
      })
    end
  end

  test "to and from record test" do
    schema = %Transaction{
      buyer_id: "buyer_id",
      seller_id: "seller_id",
      widget_id: "widget_id"
    }

    assert schema == schema |> Transaction.to_record() |> Transaction.from_record()
  end
end
