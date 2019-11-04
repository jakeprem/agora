defmodule Mix.Tasks.Db.Purge do
  use Mix.Task

  @shortdoc "Sets up the database and tables"
  def run(_) do
    Agora.Setup.purge()
  end
end
