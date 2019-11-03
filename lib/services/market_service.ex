defmodule Agora.MarketService do
  @moduledoc """

  """

  alias Agora.IdService

  @tablename MarketItem
  @attributes [:id, :seller, :name, :description, :price]

  def init do
    case :mnesia.create_table(MarketItem, attributes: @attributes, disc_copies: [node()]) do
      {:atomic, :ok} ->
        :ok

      {:aborted, {:already_exists, MarketItem}} ->
        {:ok, "MarketItem table already created"}

      {:aborted, reason} ->
        {:error, reason}
    end
  end

  def sell_widget(seller, name, description, price) when is_number(price) do
    new_listing = {
      @tablename,
      IdService.generate_id(),
      seller,
      name,
      description,
      price
    }

    :mnesia.transaction(fn ->
      :mnesia.write(new_listing)
    end)
    |> case do
      {:atomic, :ok} -> {:ok, new_listing}
      other -> {:error, other}
    end
  end

  def list_widgets do
    :mnesia.transaction(fn ->
      :mnesia.match_object({@tablename, :_, :_, :_, :_, :_})
    end)
    |> case do
      {:atomic, widgets} -> {:ok, widgets}
      other -> {:error, other}
    end
  end
end
