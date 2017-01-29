defmodule Noegen.UserController do
  use Noegen.Web, :controller

  alias Noegen.User

  def create(conn, params) do
    changeset = User.registration_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user, :access)
        jwt_token = Guardian.Plug.current_token(new_conn)

        new_conn
        |> put_status(:created)
        |> render(Noegen.SessionView, "show.json", user: user, jwt: jwt_token)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Noegen.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
