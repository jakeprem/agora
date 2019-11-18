defmodule AgoraWeb.AuditView do
  use AgoraWeb, :live_view

  alias Agora.Schemas.Account
  alias Agora.Schemas.Transaction
  alias Agora.Schemas.Widget

  def render(assigns) do
    ~L"""
      <div class="audit">
        <h1 class="audit__title">Audit Log</h1>
        <ul>
          <%= for event <- @events do %>
          <li><%= inspect(event) %></li>
          <% end %>
        </ul>
      </div>
    """
  end

  def mount(_session, socket) do
    AgoraWeb.Endpoint.subscribe(Account.update_channel())

    {:ok, assign(socket, events: [])}
  end

  def handle_info(msg, socket) do
    {:noreply, assign(socket, events: [msg | socket.assigns.events])}
  end
end
