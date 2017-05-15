defmodule Noegen.UserController do
  use Noegen.Web, :controller

  alias Noegen.User

  @spec show(struct, map) :: struct
  def show(conn, %{"id" => "current"}) do
    case Guardian.Plug.current_resource(conn) do
      nil -> render(conn, Noegen.ErrorView, "error.json", status: 401)
      user -> render(conn, "show.json", user: user)
    end
  end

  @spec create(struct, map) :: struct
  def create(conn, params) do
    changeset = User.registration_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user, :access)
        jwt_token = Guardian.Plug.current_token(new_conn)

        new_conn
        |> put_status(:created)
        |> render(
          Noegen.SessionView,
          "show.json",
          user: user,
          jwt_token: jwt_token
        )
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Noegen.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
