defmodule ChuckWeb.JokesOverviewLive do
  use ChuckWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:jokes, nil)
      |> assign(:error, nil)

    {:ok, socket}
  end

  def handle_event("search_jokes", %{"query" => query}, socket) when byte_size(query) < 3 do
    {:noreply,
     assign(socket, jokes: nil, error: "search query must contain more than 3 characters")}
  end

  def handle_event("search_jokes", %{"query" => query}, socket) do
    case Chuck.search_jokes(query) do
      {:ok, jokes} ->
        {:noreply, assign(socket, jokes: jokes, error: nil)}

      {:error, _} ->
        {:noreply, assign(socket, jokes: nil, error: "something went wrong!")}
    end
  end

  def handle_event("add_to_favorites", %{"id" => id}, socket) do
    user = socket.assigns.current_user

    # @TODO: check current favorites to provide UI feedback, handle error path
    Chuck.add_to_favorites(user.id, id)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-7xl mb-8">Chuck McChuckface</h1>
    <h2 class="text-2xl">Search Chuck Norris jokes:</h2>
    <form phx-change="search_jokes" phx-submit="search_jokes">
      <input class="mb-8 w-full" type="text" name="query" phx-debounce="1000" />
    </form>

    <%= if @error do %>
      <p class="mb-8"><%= @error %></p>
    <% end %>

    <%= if @jokes != nil do %>
      <%= if length(@jokes) == 0 do %>
        <p class="mb-8">No results found</p>
      <% end %>
      <%= for joke <- @jokes do %>
        <div class="mb-8">
          <p class="text-xl mb-2"><%= joke.value %></p>
          <button phx-click="add_to_favorites" phx-value-id={joke.id}>> add to favorites</button>
        </div>
      <% end %>
    <% end %>
    """
  end
end
