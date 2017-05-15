defmodule Noegen.PageController do
  use Noegen.Web, :controller

  @spec index(struct, map) :: struct
  def index(conn, _params) do
    render conn, "index.html"
  end
end
