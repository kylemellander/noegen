defmodule Noegen.SessionView do
  use Noegen.Web, :view

  def render("show.json", %{user: user, jwt_token: jwt_token}) do
    %{
      data: render_one(user, Noegen.UserView, "user.json"),
      meta: %{token: jwt_token}
    }
  end

  def render("error.json", _) do
    %{error: "Invalid email and/or password"}
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("forbidden.json", %{error: error}) do
    %{error: error}
  end
end
