defmodule AgoraWeb.MarketLiveView do
  use AgoraWeb, :live_view

  alias Agora.AccountService
  alias Agora.MarketService

  alias Agora.Schemas.Account
  alias Agora.Schemas.Widget

  @account_channel Account.update_channel()
  @widget_channel Widget.update_channel()

  def render(assigns) do
    ~L"""
    <div class="root">
      <header class="root__header">
      <%= if @account == nil do %>
      <form phx-submit="create_account">
        <b>CREATE</b>
        <input name="account[first_name]" type="text" placeholder="First Name...">
        <input name="account[last_name]" type="text" placeholder="Last Name...">
        <b>OR LOGIN</b>
        <input name="id" type="text" placeholder="ID">
        <button action="submit">Login</button>
      </form>
      <% else %>
      ID: <%= @account.id %> ·
      Welcome, <%= live_link to: Routes.live_path(@socket, AgoraWeb.AccountView, @account.id) do %><%= "#{@account.first_name} #{@account.last_name}" %><% end %> · Balance: <%= @account.balance %>
      <% end %>
      </header>
      <main role="main" class="root__main">
        <div class="market">
          <h1 class="market__title">Widgets for Sale</h1>
          <div class="market__table">
            <table class="mkt-table">
              <thead>
              <%= for attr <- Widget.attributes() do %>
                <th class="mkt-table__th mkt-table__cell"><%= attr |> Atom.to_string() |> String.capitalize() %>
              <% end %>
              <%= unless @account == nil do %>
                <th class="mkt-table__th mkt-table__cell"></th>
              <% end %>
              </thead>
              <%= for {_id, widget} <- @widgets do %>
              <tr class="mkt-table__tr">
                <%= for attr <- Widget.attributes() do %>
                <td class="mkt-table__cell mkt-table__cell--break"><%= Map.get(widget, attr) %></td>
                <% end %>
                <%= unless @account == nil do %>
                <td class="mkt-table_-cell"><button phx-click="buy", phx-value-widget="<%= widget.id %>">Buy</button></td>
                <% end %>
              </tr>
              <% end %>
            </table>
          </div>
        </div>
      </main>
    </div>
    """
  end

  def mount(_session, socket) do
    socket =
      socket
      |> fetch_widgets()
      |> assign(account: nil)

    {:ok, socket}
  end

  def handle_info(%{event: "update", payload: widget, topic: @widget_channel}, socket) do
    {:noreply, add_widget(socket, widget)}
  end

  def handle_info(%{event: "update", payload: updated_account, topic: @account_channel <> _account_id}=msg, socket) do
    msg |> IO.inspect(label: "market_live_view.ex:79")

    {:noreply, assign(socket, account: updated_account)}
  end

  def handle_event("buy", %{"widget" => widget_id}, socket) do
    {:ok, _transaction} = MarketService.buy_widget(socket.assigns.account.id, widget_id)
    {:noreply, socket}
  end

  def handle_event("create_account", %{"account" => account, "id" => ""}, socket) do
    {:ok, account} = AccountService.create(account["first_name"], account["last_name"])
    {:noreply, assign(socket, account: account)}
  end

  def handle_event("create_account", %{"id" => id}, socket) do
    {:noreply, fetch_account(socket, id)}
  end

  defp fetch_account(socket, id) do
    {:ok, account} = AccountService.get(id) |> IO.inspect(label: "market_live_view.ex:99")

    AgoraWeb.Endpoint.subscribe(@account_channel <> id)

    assign(socket, account: account)
  end

  defp fetch_widgets(socket) do
    {:ok, widgets} = MarketService.list_widgets()
    widget_map = widgets |> Enum.map(&{&1.id, &1}) |> Enum.into(Map.new)

    AgoraWeb.Endpoint.subscribe(@widget_channel)

    assign(socket, widgets: widget_map)
  end

  defp add_widget(socket, widget) do
    old_widgets = socket.assigns.widgets

    new_widgets =
      case widget.is_for_sale do
        true -> Map.put(old_widgets, widget.id, widget)
        false -> Map.delete(old_widgets, widget.id)
      end

    assign(socket, widgets: new_widgets)
  end
end
