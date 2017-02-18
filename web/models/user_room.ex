defmodule Noegen.UserRoom do
  @moduledoc """
    The join table between User and Room
  """
  use Noegen.Web, :model

  schema "user_rooms" do
    belongs_to :user, Noegen.User
    belongs_to :room, Noegen.Room

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(struct, map) :: struct
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
    |> unique_constraint(:user_id_room_id)
  end
end
