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

  @doc """
  Creates `priv/db` if it doesn't exist. Creates the :mnesia schema and creates the tables.
  """
  def setup do
    setup_path()

    create_schema_and_start()
    create_tables()
  end

  @doc """
  Create the schema if it doesn't exist and start :mnesia
  """
  def create_schema_and_start do
    setup_path()
    current_node = node()

    case :mnesia.create_schema([current_node]) do
      :ok -> :mnesia.start()
      {:error, {^current_node, {:already_exists, ^current_node}}} -> :mnesia.start()
      other -> raise "Something unexpected happened while starting Mnesia (#{other})"
    end
  end

  defp create_tables do
    AccountRepo.init()
    TransactionRepo.init()
    WidgetRepo.init()
  end

  @doc """
  Wait for tables to be loaded by :mnesia
  """
  def wait_for_tables do
    :mnesia.wait_for_tables([Account, Transaction, Widget], 5_000)
  end

  @doc """
  Clear all records in all three tables
  """
  def clear_tables do
    :mnesia.clear_table(Account)
    :mnesia.clear_table(Transaction)
    :mnesia.clear_table(Widget)
  end

  @doc """
  Deletes :mnesia schema and tables for this environment.

  WARNING: This will delete all saved data.
  """
  def purge do
    require Logger
    Logger.warn("Purging database for #{Mix.env()}")

    storage_path =
      :mnesia
      |> Application.get_env(:dir)
      |> List.to_string()

    System.cmd("rm", ["-r", storage_path])
  end

  # Create the configured path.
  # Has no effect if it already exists.
  defp setup_path do
    storage_path = Application.get_env(:mnesia, :dir)
    File.mkdir_p(storage_path)
  end
end
