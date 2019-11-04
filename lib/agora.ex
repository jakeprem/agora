defmodule Agora do
  @moduledoc """
  Documentation for Agora.
  """

  def initialize_app do
    Agora.AccountRepo.init()
    Agora.TransactionRepo.init()
    Agora.WidgetRepo.init()
  end
end
