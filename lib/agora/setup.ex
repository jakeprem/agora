defmodule Agora.Setup do
  alias Agora.{
    AccountRepo,
    TransactionRepo,
    WidgetRepo
  }

  alias Agora.Schemas.{
    Account,
    Transaction,
    Widget
  }

  def setup do
    storage_path = Application.get_env(:mnesia, :dir)
    File.mkdir_p(storage_path)

    create_schema_and_start()
    create_tables()
  end

  def create_schema_and_start do
    current_node = node()

    case :mnesia.create_schema([current_node]) do
      :ok -> :mnesia.start()
      {:error, {^current_node, {:already_exists, ^current_node}}} -> :mnesia.start()
      _ -> raise "Something unexpected happened while starting Mnesia"
    end
  end

  defp create_tables do
    AccountRepo.init()
    TransactionRepo.init()
    WidgetRepo.init()
  end

  def wait_for_tables do
    :mnesia.wait_for_tables([Account, Transaction, Widget], 5_000)
  end

  def clear_tables do
    :mnesia.clear_table(Account)
    :mnesia.clear_table(Transaction)
    :mnesia.clear_table(Widget)
  end

  def purge do
    require Logger
    Logger.warn("Purging database for #{Mix.env()}")

    storage_path =
      :mnesia
      |> Application.get_env(:dir)
      |> List.to_string()

    System.cmd("rm", ["-r", storage_path])
  end
end
