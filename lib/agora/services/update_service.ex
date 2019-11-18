defmodule Agora.UpdateService do
  @moduledoc """
  Exposes events on the Mnesia tables
  """
  alias Agora.AccountRepo
  alias Agora.TransactionRepo
  alias Agora.WidgetRepo

  def subscribe_all do
    subscribe_accounts()
    subscribe_transactions()
    subscribe_widgets()
  end

  def subscribe_accounts do
    AccountRepo.subscribe()
  end

  def subscribe_transactions do
    TransactionRepo.subscribe()
  end

  def subscribe_widgets do
    WidgetRepo.subscribe()
  end
end
