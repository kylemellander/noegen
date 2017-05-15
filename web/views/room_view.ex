defmodule Noegen.RoomView do
  use Noegen.Web, :view

  def render("index.json", %{rooms: rooms}) do
    %{data: render_many(rooms, Noegen.RoomView, "room.json")}
  end

  def render("show.json", %{room: room}) do
    %{data: render_one(room, Noegen.RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{id: room.id,
      type: "rooms",
      attributes: %{
        name: room.name,
        topic: room.topic
      },
      relationships: %{
        users: render_many(room.users, Noegen.UserView, "relationship.json")
      }
    }
  end
end
