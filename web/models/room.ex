defmodule Noegen.Room do
  @moduledoc """
  A room for containing a group of people to have messages specific to this
  room.

  Relationships:
    - has_and_belongs_to_many Users
  """
  use Noegen.Web, :model

  schema "rooms" do
    field :name, :string
    field :topic, :string

    many_to_many :users, Noegen.User, join_through: "users_rooms"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(struct, map) :: struct
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :topic])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
