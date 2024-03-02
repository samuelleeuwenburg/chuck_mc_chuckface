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
    |> changeset(params)
    |> put_assoc(:user, user)
    |> Repo.insert()
  end

  def changeset(list, params \\ %{}) do
    list
    |> cast(params, [:jokes])
  end

  def add_joke(list, id) do
    jokes = [id | get_joke_ids(list)] |> serialize_ids

    changeset(list, %{jokes: jokes})
  end

  def remove_joke(list, id) do
    jokes = get_joke_ids(list) |> List.delete(id) |> serialize_ids

    changeset(list, %{jokes: jokes})
  end

  def get_joke_ids(list) do
    case list.jokes do
      nil -> []
      jokes -> jokes |> String.split(",")
    end
  end

  defp serialize_ids(ids) do
    ids |> Enum.dedup() |> Enum.join(",")
  end
end
