defmodule Chuck.Repo.Migrations.JokeList do
  use Ecto.Migration

  def change do
    create table(:joke_list) do
      add :user_id, references(:users)
      add :jokes, :text, null: true

      timestamps()
    end
  end
end
