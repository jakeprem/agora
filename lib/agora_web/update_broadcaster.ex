defmodule AgoraWeb.UpdateBrodcaster do
  use GenServer

  alias Agora.UpdateService

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    UpdateService.subscribe_all()

    {:ok, nil}
  end

  def handle_info({:mnesia_table_event, {:write, record, _something}}, state) do
    assumed_schema = elem(record, 0)

    data_struct = apply(assumed_schema, :from_record, [record])
    update_channel = apply(assumed_schema, :update_channel, [])

    AgoraWeb.Endpoint.broadcast!(update_channel, "update", data_struct)
    AgoraWeb.Endpoint.broadcast!(update_channel <> data_struct.id, "update", data_struct)
    {:noreply, state}
  end

  def handle_info(msg, state) do
    msg |> IO.inspect(label: "MESSAGE")

    {:noreply, state}
  end
end
