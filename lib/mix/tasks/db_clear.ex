defmodule Mix.Tasks.Db.Clear do
  use Mix.Task

  @shortdoc "Sets up the database and tables"
  def run(_) do
    Agora.Setup.clear_tables()
  end
end
