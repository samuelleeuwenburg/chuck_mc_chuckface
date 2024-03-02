defmodule ChuckWeb.JokesOverviewLive do
  use ChuckWeb, :live_view

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    user_favorites =
      Chuck.get_favorite_list_for_user(user.id)
      |> Chuck.JokeList.get_joke_ids()

    socket =
      socket
      |> assign(:user_favorites, user_favorites)
      |> assign(:jokes, nil)
      |> assign(:error, nil)
      |> assign(:query, "")

    {:ok, socket}
  end

  def handle_event("search_jokes", %{"query" => query}, socket) when byte_size(query) < 3 do
    {:noreply,
     assign(socket,
       jokes: nil,
       query: query,
       error: "search query must contain more than 3 characters"
     )}
  end

  def handle_event("search_jokes", %{"query" => query}, socket) do
    case Chuck.search_jokes(query) do
      {:ok, jokes} ->
        {:noreply, assign(socket, query: query, jokes: jokes, error: nil)}

      {:error, _} ->
        {:noreply, assign(socket, query: query, jokes: nil, error: "something went wrong!")}
    end
  end

  def handle_event("add_to_favorites", %{"id" => id}, socket) do
    user = socket.assigns.current_user

    Chuck.add_to_favorites(user.id, id)

    user_favorites =
      Chuck.get_favorite_list_for_user(user.id)
      |> Chuck.JokeList.get_joke_ids()

    {:noreply, assign(socket, user_favorites: user_favorites)}
  end

  def handle_event("remove_from_favorites", %{"id" => id}, socket) do
    user = socket.assigns.current_user

    Chuck.remove_from_favorites(user.id, id)

    user_favorites =
      Chuck.get_favorite_list_for_user(user.id)
      |> Chuck.JokeList.get_joke_ids()

    {:noreply, assign(socket, user_favorites: user_favorites)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-6xl mb-8">Chuck McChuckface</h1>
    <h2 class="text-2xl">Search Chuck Norris jokes:</h2>
    <form phx-change="search_jokes" phx-submit="search_jokes">
      <input class="mb-8 w-full" type="text" name="query" value={@query} phx-debounce="400" />
    </form>

    <%= if @error do %>
      <p class="mb-8"><%= @error %></p>
    <% end %>

    <%= if @jokes != nil do %>
      <%= if length(@jokes) == 0 do %>
        <p class="mb-8">No results found</p>
      <% end %>
      <%= for joke <- @jokes do %>
        <div class="mb-4">
          <p class="text-xl mb-4"><%= joke.value %></p>

          <div class="mb-4 text-[#333]">
            <%= if Enum.member?(@user_favorites, joke.id) do %>
              <button phx-click="remove_from_favorites" phx-value-id={joke.id}>
                > <strong>remove</strong> from favorites
              </button>
            <% else %>
              <button phx-click="add_to_favorites" phx-value-id={joke.id}>
                > <strong>add</strong> to favorites
              </button>
            <% end %>
          </div>

          <hr />
        </div>
      <% end %>
    <% end %>
    """
  end
end
