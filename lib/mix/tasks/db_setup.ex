defmodule Mix.Tasks.Db.Setup do
  use Mix.Task

  @shortdoc "Sets up the database and tables"
  def run(_) do
    Agora.Setup.setup()
  end
end
