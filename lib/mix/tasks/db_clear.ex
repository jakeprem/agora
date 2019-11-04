defmodule Mix.Tasks.Db.Clear do
  @moduledoc """
  Delete all records from all the tables
  """
  use Mix.Task

  def run(_) do
    Agora.Setup.clear_tables()
  end
end
