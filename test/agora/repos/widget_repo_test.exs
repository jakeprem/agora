defmodule Agora.WidgetRepoTest do
  use ExUnit.Case

  alias Agora.Schemas.Widget
  alias Agora.WidgetRepo

  setup_all do
    Agora.Setup.create_schema_and_start()

    :ok
  end

  setup do
    Agora.Setup.clear_tables()

    :ok
  end

  describe "write/1 and read/1" do
    test "writes and returns widget with valid id" do
      new_widget = Widget.new("an_owner", "Something", "A description", true, 5.0)

      :mnesia.transaction(fn ->
        WidgetRepo.write(new_widget)
      end)

      assert {:atomic, widget} =
               :mnesia.transaction(fn ->
                 WidgetRepo.read(new_widget.id)
               end)

      assert widget == new_widget
    end

    test "read/1 returns nil when widget does not exist" do
      assert {:atomic, nil} =
               :mnesia.transaction(fn ->
                 WidgetRepo.read("does_not_exist")
               end)
    end
  end

  describe "list_for_sale/0" do
    test "returns only widgets marked as for sale" do
      widget_a = Widget.new("owner_a", "Something", "some text", true, 9001.0)
      widget_b = Widget.new("owner_b", "Another Thing", "some other text", false, 0.0)

      :mnesia.transaction(fn ->
        WidgetRepo.write(widget_a)
        WidgetRepo.write(widget_b)
      end)

      assert {:atomic, widgets} =
               :mnesia.transaction(fn ->
                 WidgetRepo.list_for_sale()
               end)

      assert length(widgets) == 1
      assert Enum.member?(widgets, widget_a)
      refute Enum.member?(widgets, widget_b)
    end
  end
end
