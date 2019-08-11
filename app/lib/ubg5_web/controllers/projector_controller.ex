defmodule Ubg5Web.ProjectorController do
  use Ubg5Web, :controller
  alias Ubg5.Projector

  plug(:put_layout, "projector.html")

  def index(conn, _params) do
    conn = fetch_query_params(conn)

    case Map.fetch(conn.query_params, "proj_id") do
      {:ok, proj_id} ->
        verse = Projector.get_verse(proj_id)
        out = case Projector.get_verse(proj_id) do
                nil -> ""
                verse -> verse.bible <> ";" <>
                    verse.book_short_code <> ";" <>
                    Integer.to_string(verse.chapter_number) <> ";" <>
                    Integer.to_string(verse.verse_number) <> ";" <>
                    verse.text
              end
        
        conn
        |> put_resp_content_type("text/plain", "utf-8")
        |> send_resp(200, out)
      :error ->
        conn
        |> assign(:proj_id, UUID.uuid1())
        |> render()
    end
  end

  def set_verse(conn, _params) do
    {:ok, body, conn} = read_body(conn)
    [proj_id, bible, book_name, chapter_number, verse_number] = String.split(body, ";")
    {chapter_number, _} = Integer.parse(chapter_number)
    IO.inspect({:body, body})
    {verse_number, _} = Integer.parse(verse_number)
    Projector.set_verse(proj_id, bible, book_name, chapter_number, verse_number)
    send_resp(conn, 200, "ok")
  end
end
