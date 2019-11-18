defmodule Agora.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      AgoraWeb.Endpoint,
      AgoraWeb.UpdateBrodcaster,
    ]

    start_mnesia()

    opts = [strategy: :one_for_one, name: Agora.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp start_mnesia do
    Agora.Setup.create_schema_and_start()
    Agora.Setup.wait_for_tables()
  end
end
