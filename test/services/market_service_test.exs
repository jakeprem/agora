defmodule Agora.MarketServiceTest do
  use ExUnit.Case

  alias Agora.MarketService
  alias Agora.UserService

  setup_all do
    MarketService.init()

    :ok
  end

  setup do
    :mnesia.clear_table(MarketItem)

    :ok
  end

  test "User can add widgets" do
    {:ok, {User, user_id, _, _}} = UserService.create("Jack", "Ryan")

    assert {:ok, listing} =
             MarketService.sell_widget(user_id, "A Rock", "It's a really cool rock.", 10.00)
  end

  test "User can list widgets for sale" do
    {:ok, widget_a} = MarketService.sell_widget("some_id", "Item A", "It's item A", 10.00)
    {:ok, widget_b} = MarketService.sell_widget("some_id", "Item B", "It's item B", 15.00)

    assert {:ok, widgets} = MarketService.list_widgets()
    assert length(widgets) == 2
    assert Enum.member?(widgets, widget_a)
    assert Enum.member?(widgets, widget_b)
  end

  test "User can buy widgets"
end
