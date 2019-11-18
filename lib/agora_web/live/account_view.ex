defmodule AgoraWeb.AccountView do
  use AgoraWeb, :live_view

  alias Agora.AccountService

  def render(assigns) do
    ~L"""
    <%= inspect(@account) %>
    <ul>
      <%= for widget <- @widgets do %>
      <li><%= inspect(widget) %></li>
      <% end %>
    </ul>
    """
  end

  def mount(_session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    {:ok, account} = AccountService.get(id)
    {:ok, widgets} = AccountService.get_widgets(id)
    {:noreply, assign(socket, account: account, widgets: widgets)}
  end
end
