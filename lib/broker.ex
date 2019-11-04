defmodule Agora.Broker do
  @moduledoc """
  An IEx user interface for interacting with the application. All user actions are exposed on this module.

  Right now all functionality is provided using defdelegate however this could be a place to build
  """

  alias Agora.AccountService
  alias Agora.MarketService

  defdelegate create_account(first_name, last_name), to: AccountService, as: :create

  defdelegate add_funds(account_id, amount), to: AccountService

  def view_balance(_account_id) do
    :not_implemented
  end

  defdelegate buy_widget(buyer_id, widget_id), to: MarketService

  defdelegate sell_widget(seller_id, name, description, price), to: MarketService

  defdelegate list_widgets(), to: MarketService
end
