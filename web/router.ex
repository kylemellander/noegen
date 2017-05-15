defmodule Noegen.Router do
  use Noegen.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", Noegen do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Noegen do
    pipe_through :api

    post "/sessions", SessionController, :create
    delete "/sessions", SessionController, :delete
    post "/sessions/refresh", SessionController, :refresh
    resources "/users", UserController, only: [:create, :show]
    get "/users/:id/rooms", UserController, :rooms
    get "/users/:id/relationships/rooms", RoomController, :relationship
    post "/rooms/:id/join", RoomController, :join
    resources "/rooms", RoomController, except: [:new, :edit]
  end
end
