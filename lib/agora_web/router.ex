defmodule AgoraWeb.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug Plug.Logger
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Plug.Logger
  end

  scope "/", AgoraWeb do
    pipe_through :browser

    live "/market", MarketLiveView
    live "/audit", AuditView
    live "/account/:id", AccountView, session: [:path_params]
  end

  forward "/api", AgoraWeb.ApiRouter
end
