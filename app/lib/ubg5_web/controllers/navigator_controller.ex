defmodule Ubg5Web.NavigatorController do
  use Ubg5Web, :controller
  alias Ubg5.Bibles

  plug(:put_layout, "navigate.html")

  def index(conn, params.bible) do
    conn = fetch_query_params(conn)

    case Map.get(conn.query_params, "verse") do
      nil ->
        render(conn)
      verse ->
        search_and_redirect(conn, params.bible, verse)
    end
  end

  def search_and_redirect(conn, verse) do
    case Bibles.get_verse_address_from_string(verse) do
      nil -> render(conn)
      { bible_short_code, book_slug_name, chapter_number, verse_from, verse_to } ->
        # redirect
    end
  end
end
