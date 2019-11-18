defmodule AgoraWeb.ApiRouter do
  @moduledoc """
  Provides an HTTP API as an interface to the application.
  """
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["test/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  alias Agora.AccountService
  alias Agora.MarketService

  post "/accounts" do
    %{"first_name" => first_name, "last_name" => last_name} = conn.params

    with {:ok, account} <- AccountService.create(first_name, last_name) do
      json_resp(conn, 201, account)
    else
      {:error, error} -> send_resp(conn, 500, inspect(error))
    end
  end

  post "/accounts/add_funds" do
    %{"account_id" => account_id, "amount" => amount} = conn.params

    with {:ok, account} <- AccountService.add_funds(account_id, amount) do
      json_resp(conn, 200, account)
    else
      {:error, error} -> send_resp(conn, 500, inspect(error))
    end
  end

  get "/widgets" do
    with {:ok, widgets} <- MarketService.list_widgets() do
      json_resp(conn, 200, widgets)
    else
      {:error, error} -> send_resp(conn, 500, error)
    end
  end

  post "widgets/buy" do
    %{"buyer_id" => buyer_id, "widget_id" => widget_id} = conn.params

    with {:ok, transaction} <- MarketService.buy_widget(buyer_id, widget_id) do
      json_resp(conn, 200, transaction)
    else
      {:error, error} -> send_resp(conn, 400, error)
    end
  end

  post "widgets/sell" do
    %{"seller_id" => seller_id, "name" => name, "description" => description, "price" => price} =
      conn.params

    with {:ok, widget} <- MarketService.sell_widget(seller_id, name, description, price) do
      json_resp(conn, 200, widget)
    else
      {:error, error} -> send_resp(conn, 400, error)
    end
  end

  match _ do
    send_resp(conn, 404, "No route found")
  end

  defp json_resp(conn, status, data) do
    send_resp(conn, status, Jason.encode!(data))
  end
end
