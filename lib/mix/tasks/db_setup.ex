defmodule Mix.Tasks.Db.Setup do
  @moduledoc """
  Sets up the database and tables
  """
  use Mix.Task

  def run(_) do
    Agora.Setup.setup()
  end
end
