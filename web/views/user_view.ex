defmodule Noegen.UserView do
  use Noegen.Web, :view

  def render("show.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        type: "user",
        attributes: %{
          username: user.username,
          email: user.email
        }
      }
    }
  end
end
