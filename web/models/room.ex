defmodule Noegen.Room do
  use Noegen.Web, :model

  schema "rooms" do
    field :name, :string
    field :topic, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :topic])
    |> validate_required([:name, :topic])
  end
end
