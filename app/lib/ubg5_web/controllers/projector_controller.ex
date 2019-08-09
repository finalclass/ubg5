defmodule Ubg5Web.ProjectorController do
  use Ubg5Web, :controller

  plug(:put_layout, "projector.html")

  def index(conn, _params) do
    conn = fetch_query_params(conn)

    case Map.fetch(conn.query_params, "proj_id") do
      {:ok, proj_id} ->
        conn
        |> assign(:proj_id, "okok")
        |> render()

      :error ->
        conn
        |> put_resp_content_type(conn, "text/plain", "utf-8")
        |> send_resp(200, "OK")
    end
  end

  def set_verse(conn, _params) do
    # set(current(verse))
    send_resp(conn, 200, "ok")
  end
end
