defmodule Agora do
  @moduledoc """
  Documentation for Agora.
  """

  def initialize_app do
    Agora.UserService.init()
    Agora.MarketService.init()
  end
end
