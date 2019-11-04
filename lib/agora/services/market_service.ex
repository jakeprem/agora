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

  def sell_widget(seller_id, name, description, price) when is_number(price) do
    widget = Widget.new(seller_id, name, description, true, price)

    :mnesia.transaction(fn ->
      WidgetRepo.write(widget)
    end)
    |> case do
      {:atomic, :ok} -> {:ok, widget}
      {:aborted, reason} -> {:error, reason}
    end
  end

  def buy_widget(buyer_id, widget_id) do
    :mnesia.transaction(fn ->
      buyer = AccountRepo.read(buyer_id)
      widget = WidgetRepo.read(widget_id)
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
