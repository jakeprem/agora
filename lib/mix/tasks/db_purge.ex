defmodule Mix.Tasks.Db.Purge do
  @moduledoc """
  Deletes the database and all database files for the current environment
  """
  use Mix.Task

  def run(_) do
    Agora.Setup.purge()
  end
end
