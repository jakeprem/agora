defmodule Agora.WidgetRepo do
  alias Agora.Schemas.Widget

  @tablename Widget
  @attributes Widget.attributes()

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

  def write(%Widget{} = widget) do
    widget
    |> Widget.to_record()
    |> :mnesia.write()
  end

  def read(widget_id) do
    {Widget, widget_id}
    |> :mnesia.read()
    |> List.first()
    |> Widget.from_record()
  end

  def list do
    :mnesia.match_object({@tablename, :_, :_, :_, :_, :_, :_})
    |> Enum.map(&Widget.from_record/1)
  end
end
