defmodule AgoraWeb do
  @port 4040

  def spec do
    {Plug.Cowboy, scheme: :http, plug: AgoraWeb.Router, options: [port: @port]}
  end
end
