defmodule Agora.MarketService do
  @moduledoc """
  Service for listing and buying widgets
  """
  @platform_cut 0.05

  alias Agora.Schemas.Account
  alias Agora.Schemas.Transaction
  alias Agora.Schemas.Widget

  alias Agora.AccountRepo
  alias Agora.TransactionRepo
  alias Agora.WidgetRepo

  @doc """
  Post a widget for sale
  """
  def sell_widget(seller_id, name, description, price) when is_number(price) do
    :mnesia.transaction(fn ->
      widget = Widget.new(seller_id, name, description, true, price)

      with :ok <- WidgetRepo.write(widget) do
        widget
      end
    end)
    |> case do
      {:atomic, widget} -> {:ok, widget}
      {:aborted, reason} -> {:error, reason}
    end
  end

  @doc """
  Buy a widget. Will return an error if buyer doesn't have sufficient funds.
  """
  def buy_widget(buyer_id, widget_id) do
    :mnesia.transaction(fn ->
      buyer = AccountRepo.read(buyer_id)
      if buyer == nil do
        :mnesia.abort("Invalid buyer")
      end

      widget = WidgetRepo.read(widget_id)
      if widget == nil do
        :mnesia.abort("Invalid widget")
      end

      seller = AccountRepo.read(widget.owner)

      updated_buyer = %Account{
        buyer
        | balance: buyer.balance - widget.price
      }

      if updated_buyer.balance < 0 do
        :mnesia.abort("Insufficient funds. Add more funds before purchasing this widget.")
      end

      updated_seller = %Account{
        seller
        | balance: seller.balance + widget.price * (1 - @platform_cut)
      }

      AccountRepo.write(updated_buyer)
      AccountRepo.write(updated_seller)

      new_transaction = Transaction.new(buyer.id, seller.id, widget.id)

      with :ok <- TransactionRepo.write(new_transaction) do
        new_transaction
      end
    end)
    |> case do
      {:atomic, transaction} -> {:ok, transaction}
      {:aborted, reason} -> {:error, reason}
    end
  end

  @doc """
  List widgets for sale
  """
  def list_widgets do
    :mnesia.transaction(fn ->
      WidgetRepo.list()
    end)
    |> case do
      {:atomic, widgets} -> {:ok, widgets}
      {:aborted, reason} -> {:error, reason}
    end
  end
end