defmodule Noegen.UserView do
  use Noegen.Web, :view

  @spec render(string, map) :: map
  def render("show.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        type: "user",
        attributes: %{
          username: user.username,
          email: user.email
        },
        relationships: %{
          rooms: %{
            links: %{
              # self: "/users/#{user.id}/relationships/rooms",
              related: "rooms"
            }
          }
        }
      }
    }
  end

  def render("relationship.json", %{user: user}) do
    %{
      type: "user",
      id: user.id
    }
  end
end
