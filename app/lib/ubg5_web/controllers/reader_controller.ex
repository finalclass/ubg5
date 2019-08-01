defmodule Ubg5Web.ReaderController do
  use Ubg5Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
