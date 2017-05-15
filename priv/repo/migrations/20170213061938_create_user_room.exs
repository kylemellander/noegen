defmodule Noegen.Repo.Migrations.CreateUsersRooms do
  use Ecto.Migration

  def change do
    create table(:users_rooms) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :room_id, references(:rooms, on_delete: :nothing), null: false
    end
    create index(:users_rooms, [:user_id])
    create index(:users_rooms, [:room_id])
    create index(:users_rooms, [:user_id, :room_id], unique: true)
  end
end
