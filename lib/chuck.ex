defmodule Chuck do
  @moduledoc """
  Chuck allows you to query chuck norris jokes and save these in a favorite list
  """

  import Ecto.Query
  alias Chuck.JokesAPI
  alias Chuck.Repo
  alias Chuck.JokeList

  @doc """
  Search for jokes based on a given search query.

  Returns a list of matching jokes, empty if none are found
  """
  def search_jokes(query) do
    JokesAPI.search(query)
  end

  @doc """
  Add a joke to a user's favorite list
  """
  def add_to_favorites(user_id, id) do
    query =
      from list in JokeList,
        where: list.user_id == ^user_id

    Repo.one(query)
    |> JokeList.add_joke(id)
    |> Repo.update()
  end

  @doc """
  Get favorite joke_list associated to a given user id
  """
  def get_favorite_list_for_user(user_id) do
    query =
      from list in JokeList,
        where: list.user_id == ^user_id

    Repo.one(query)
  end

  @doc """
  Fetch all remote jokes based on the list id
  """
  def get_jokes(id) do
    case Repo.get(JokeList, id) do
      nil ->
        {:error, :not_found}

      %{jokes: nil} ->
        {:error, :no_favorites}

      list ->
        jokes =
          list
          |> JokeList.get_joke_ids()
          # run all get queries in parallel
          |> Enum.map(&Task.async(fn -> JokesAPI.get(&1) end))
          |> Task.await_many()
          # filter out requests that didn't succeeed
          |> Enum.filter(fn {status, _} -> status != :error end)
          |> Enum.map(fn {_, joke} -> joke end)

        {:ok, jokes}
    end
  end
end
