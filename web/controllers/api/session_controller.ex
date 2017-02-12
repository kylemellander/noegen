defmodule Noegen.SessionController do
  use Noegen.Web, :controller

  def create(conn, params) do
    case authenticate(params) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user, :access)
        jwt_token = Guardian.Plug.current_token(new_conn)

        render_show(new_conn, jwt_token: jwt_token)
      :unauthorized ->
        unauthorized(conn)
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.current_token()
    |> Guardian.revoke!()

    conn
    |> put_status(:ok)
    |> render("delete.json")
  end

  def refresh(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    jwt_token = Guardian.Plug.current_token(conn)
    {:ok, claims} = Guardian.Plug.claims(conn)

    case Guardian.refresh!(jwt_token, claims, %{ttl: {7, :days}}) do
      {:ok, new_jwt_token, _} ->
        render_show(conn, user: user, jwt_token: new_jwt_token)
      _ ->
        unauthorized(conn)
    end
  end

  def unauthenticated(conn, _) do
    conn
    |> put_status(:forbidden)
    |> render("forbidden.json")
  end

  defp authenticate(%{"email" => email, "password" => password}) do
    user = Repo.get_by(Noegen.User, email: String.downcase(email))

    case credentials_valid?(user, password) do
      true -> {:ok, user}
      _ -> :unauthorized
    end
  end
  defp authenticate(_) do
    :unauthorized
  end

  defp credentials_valid?(user, password) do
    case user do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> render("unauthorized.json")
  end

  defp render_show(conn, params) do
    conn
    |> put_status(:ok)
    |> render("show.json", params)
  end
end
