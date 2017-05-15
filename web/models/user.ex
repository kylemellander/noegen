defmodule Noegen.User do
  @moduledoc """
  Model for Users
  """
  use Noegen.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    many_to_many :rooms, Noegen.Room, join_through: "users_rooms"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    @spec changeset(struct, params :: map \\ %{}) :: changeset

    struct
    |> cast(params, [:username, :email])
    |> validate_required([:username, :email])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  @doc """
  Builds a changeset for registering user.

  ## Parameters

    - struct: a Struct of Noegen.User
    - params: Map that contains registration parameters
      (:username, :email, :password)
  """
  def registration_changeset(struct, params) do
    @spec registration_changeset(struct, params :: map) :: changeset

    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_length(:password, min: 6, max: 100)
    |> add_password_hash()
  end

  defp add_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(
          changeset,
          :password_hash,
          Comeonin.Bcrypt.hashpwsalt(password)
        )
      _ ->
        changeset
    end
  end
end
