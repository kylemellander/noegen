defmodule Noegen.SessionView do
  use Noegen.Web, :view

  def render("show.json", %{jwt_token: jwt_token}) do
    %{token: jwt_token}
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("unauthorized.json", _) do
    %{error: "Unauthorized"}
  end

  def render("forbidden.json", _) do
    %{error: "Forbidden"}
  end
end
