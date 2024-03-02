defmodule ChuckWeb.PageController do
  use ChuckWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def joke_list(conn, params) do
    case Chuck.get_jokes(params["id"]) do
      {:ok, list} ->
        render(conn, :joke_list, list: list)

      {:error, _} ->
        conn |> Plug.Conn.put_status(404) |> halt
    end
  end

  def user_favorites(conn, _params) do
    user = conn.assigns.current_user

    with %{id: id} <- Chuck.get_favorite_list_for_user(user.id),
         {:ok, list} <- Chuck.get_jokes(id) do
      render(conn, :favorites, list: list, list_id: id)
    else
      _ -> conn |> Plug.Conn.put_status(404) |> halt
    end
  end
end
