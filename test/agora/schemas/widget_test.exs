defmodule Agora.Schemas.WidgetTest do
  use ExUnit.Case

  alias Agora.Schemas.Widget

  describe "new/2" do
    test "Generates new Widget with proper defaults" do
      widget = %Widget{
        owner: "some_id",
        name: "Some name",
        description: "some description",
        is_for_sale: true,
        price: 10.0
      }

      assert widget = Widget.new(widget.owner, widget.name, widget.description, widget.is_for_sale, widget.price)
    end
  end

  describe "to_record/1" do
    test "converts schema to record" do
      schema = %Widget{
        owner: "some_id",
        name: "Some name",
        description: "some description",
        is_for_sale: true,
        price: 10.0
      }

      assert {
        Widget,
        schema.id,
        schema.owner,
        schema.name,
        schema.description,
        schema.is_for_sale,
        schema.price
      } == Widget.to_record(schema)
    end
  end

  describe "from_record/1" do
    test "converts record to schema" do
      schema = %Widget{
        owner: "some_id",
        name: "Some name",
        description: "some description",
        is_for_sale: true,
        price: 10.0
      }

      assert schema == Widget.from_record({
        Widget,
        schema.id,
        schema.owner,
        schema.name,
        schema.description,
        schema.is_for_sale,
        schema.price
      })
    end
  end

  test "to and from record test" do
    schema = %Widget{
      owner: "some_id",
      name: "Some name",
      description: "some description",
      is_for_sale: true,
      price: 10.0
    }

    assert schema == schema |> Widget.to_record() |> Widget.from_record()
  end
end
