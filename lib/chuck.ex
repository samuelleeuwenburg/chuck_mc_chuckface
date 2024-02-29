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
  Get all favorite jokes for a given user
  """
  def get_favorites(_user) do
  end
end
