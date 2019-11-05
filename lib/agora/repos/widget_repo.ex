defmodule Agora.WidgetRepo do
  @moduledoc """
  Abstracts interacting with `Agora.Schemas.Widget` records in the Mnesia database.

  `init/0` is called as part of `Agora.Setup.setup/0` and must be run to create the table before it can be used. You can run `mix db.setup` to setup the schema and all the tables.

  `write/1`, `read/1`, and `list/0` must be called from within an `:mnesia.transaction`
  """
  alias Agora.Schemas.Widget

  @tablename Widget
  @attributes Widget.attributes()

  @doc """
  Creates the Widget table in :mnesia. The schema must be created before this command can be run.

  Running `mix db.setup` will do all of the database setup needed.
  """
  @spec init :: :ok | {:error, any} | {:ok, String.t()}
  def init do
    case :mnesia.create_table(@tablename,
           attributes: @attributes,
           disc_copies: [node()]
         ) do
      {:atomic, :ok} ->
        :ok

      {:aborted, {:already_exists, @tablename}} ->
        {:ok, "widget table already created"}

      {:aborted, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Writes the given record to the Widget table.

  Must be called from within an `:mnesia.transaction`.
  """
  @spec write(Agora.Schemas.Widget.t()) :: :ok
  def write(%Widget{} = widget) do
    widget
    |> Widget.to_record()
    |> :mnesia.write()
  end

  @doc """
  Reads the record with the given `widget_id` from the Widget table. Returns nil if not found.

  Must be called from within an `:mnesia.transaction`.
  """
  @spec read(String.t()) :: Agora.Schemas.Widget.t() | nil
  def read(widget_id) do
    {@tablename, widget_id}
    |> :mnesia.read()
    |> List.first()
    |> Widget.from_record()
  end

  @doc """
  Returns a list of all the widgets currently in the system.

  Must be called from within an `:mnesia.transaction`.
  """
  @spec list :: [Agora.Schemas.Widget.t()]
  def list do
    :mnesia.match_object({@tablename, :_, :_, :_, :_, :_, :_})
    |> Enum.map(&Widget.from_record/1)
  end

  @doc """
  Returns a list of widgets that are flagged as for sale.

  Must be called from within an `:mnesia.transaction`.
  """
  def list_for_sale do
    :mnesia.match_object({@tablename, :_, :_, :_, :_, true, :_})
    |> Enum.map(&Widget.from_record/1)
  end
end
