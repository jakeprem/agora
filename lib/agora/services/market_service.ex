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
  def sell_widget(seller_id, name, description, price) when is_number(price) and price > 0 do
    :mnesia.transaction(fn ->
      widget = Widget.new(seller_id, name, description, true, price)

      if AccountRepo.read(seller_id) == nil do
        :mnesia.abort("Invalid seller")
      end

      with :ok <- WidgetRepo.write(widget) do
        widget
      end
    end)
    |> case do
      {:atomic, widget} -> {:ok, widget}
      {:aborted, reason} -> {:error, reason}
    end
  end

  def sell_widget(_seller_id, _name, _description, price), do: {:error, "Invalid price: #{price}"}

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
      if seller == nil do
        :mnesia.abort("Could not retrieve seller account")
      end

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

      updated_widget = %Widget{
        widget
        | is_for_sale: false,
          owner: buyer.id
      }

      AccountRepo.write(updated_buyer)
      AccountRepo.write(updated_seller)
      WidgetRepo.write(updated_widget)

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
      WidgetRepo.list_for_sale()
    end)
    |> case do
      {:atomic, widgets} -> {:ok, widgets}
      {:aborted, reason} -> {:error, reason}
    end
  end
end
