defmodule Chuck.JokeList do
  alias Chuck.Repo
  alias Chuck.JokeList
  use Ecto.Schema
  import Ecto.Changeset

  schema "joke_list" do
    belongs_to :user, Chuck.Accounts.User
    field :jokes, :string

    timestamps()
  end

  def create(user, params \\ %{}) do
    %JokeList{}
    |> JokeList.changeset(params)
    |> put_assoc(:user, user)
    |> Repo.insert()
  end

  def changeset(joke_list, params \\ %{}) do
    joke_list
    |> cast(params, [:jokes])
  end

  def add_joke(joke_list, id) do
    jokes =
      if joke_list.jokes == nil do
        id
      else
        "#{joke_list.jokes},#{id}"
      end

    joke_list
    |> change(jokes: jokes)
  end
end
