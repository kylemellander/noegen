defmodule Noegen.RoomController do
  use Noegen.Web, :controller

  alias Noegen.Room

  @spec index(struct, map) :: struct
  def index(conn, _params) do
    rooms = Room |> Repo.all |> Repo.preload(:users)
    render(conn, "index.json", rooms: rooms)
  end

  @spec create(struct, map) :: struct
  def create(conn, %{"data" => %{"attributes" => attributes}}) do
    case Guardian.Plug.current_resource(conn) do
      nil -> render(conn, Noegen.ErrorView, "error.json", status: 401)
      user -> create_room(conn, user, attributes)
    end
  end

  @spec show(struct, map) :: struct
  def show(conn, %{"id" => id}) do
    room = Room |> Repo.get!(id) |> Repo.preload(:users)
    render(conn, "show.json", room: room)
  end

  @spec update(struct, map) :: struct
  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Repo.get!(Room, id)
    changeset = Room.changeset(room, room_params)

    case Repo.update(changeset) do
      {:ok, room} ->
        render(conn, "show.json", room: room)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Noegen.ChangesetView, "error.json", changeset: changeset)
    end
  end

  @spec delete(struct, map) :: struct
  def delete(conn, %{"id" => id}) do
    room = Repo.get!(Room, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(room)

    send_resp(conn, :no_content, "")
  end

  defp create_room(conn, user, attributes) do
    changeset = %Room{}
                |> Room.changeset(attributes)
                |> Ecto.Changeset.put_assoc(:users, [user])

    case Repo.insert(changeset) do
      {:ok, room} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", room_path(conn, :show, room))
        |> render("show.json", room: room)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Noegen.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
