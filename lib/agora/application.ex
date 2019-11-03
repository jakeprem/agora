defmodule Agora.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = []

    start_mnesia()

    opts = [strategy: :one_for_one, name: Agora.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp start_mnesia do
    current_node = node()

    case :mnesia.create_schema([current_node]) do
      :ok -> :mnesia.start()
      {:error, {^current_node, {:already_exists, ^current_node}}} -> :mnesia.start()
      _ -> raise "Something unexpected happened while starting Mnesia"
    end
  end
end
