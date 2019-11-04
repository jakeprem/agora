defmodule Agora.MarketServiceTest do
  use ExUnit.Case

  alias Agora.Schemas.{
    Account,
    Transaction,
    Widget
  }

  alias Agora.MarketService
  alias Agora.AccountService

  setup_all do
    Agora.Setup.setup()

    :ok
  end

  setup do
    Agora.Setup.clear_tables()

    :ok
  end

  test "User can add widgets" do
    {:ok, %Account{id: account_id}} = AccountService.create("Jack", "Ryan")

    assert {:ok, listing} =
             MarketService.sell_widget(account_id, "A Rock", "It's a really cool rock.", 10.00)
  end

  test "User can list widgets for sale" do
    {:ok, widget_a} = MarketService.sell_widget("some_id", "Item A", "It's item A", 10.00)
    {:ok, widget_b} = MarketService.sell_widget("some_id", "Item B", "It's item B", 15.00)

    assert {:ok, widgets} = MarketService.list_widgets()
    assert length(widgets) == 2
    assert Enum.member?(widgets, widget_a)
    assert Enum.member?(widgets, widget_b)
  end

  test "User can buy widgets" do
    {:ok, %Account{id: user_a}} = AccountService.create("Michael", "Scott")
    {:ok, %Account{id: user_b}} = AccountService.create("Dwight", "Schrute")

    AccountService.add_funds(user_b, 100.00)

    {:ok, %Widget{id: widget_id}} =
      MarketService.sell_widget(user_a, "Some Paper", "High quality paper", 100.0)

    {:ok, %Transaction{widget_id: ^widget_id, buyer_id: user_b, seller_id: user_a}} =
      MarketService.buy_widget(user_b, widget_id)

    assert {:ok, %Account{balance: 95.0}} = AccountService.get(user_a)
    assert {:ok, %Account{balance: 0.0}} = AccountService.get(user_b)
  end

  test "User cannot buy widget with insufficient funds" do
    {:ok, %Account{id: user_a}} = AccountService.create("Michael", "Scott")
    {:ok, %Account{id: user_b}} = AccountService.create("Dwight", "Schrute")

    AccountService.add_funds(user_b, 100.00)

    {:ok, %Widget{id: widget_id}} =
      MarketService.sell_widget(user_a, "Some Paper", "High quality paper", 1000.0)

    assert {:error, reason} = MarketService.buy_widget(user_b, widget_id)
    assert reason =~ "Insufficient funds"

    assert {:ok, %Account{balance: 0.0}} = AccountService.get(user_a)
    assert {:ok, %Account{balance: 100.0}} = AccountService.get(user_b)
  end
end
