defmodule Agora.Broker do
  alias Agora.AccountService

  defdelegate create_account(first_name, last_name), to: AccountService, as: :create

  defdelegate add_funds(account_id, amount), to: AccountService

  def view_balance(account_id) do
    :not_implemented
  end

  def buy_widget(account_id, widget_id) do
    :not_implemented
  end

  def sell_widget(account_id, widget_id) do
    :not_implemented
  end

  def list_widgets do
    :not_implemented
  end
end
