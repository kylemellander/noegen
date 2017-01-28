defmodule Noegen.PageController do
  use Noegen.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
