defmodule Ubg5Web.ReaderController do
  use Ubg5Web, :controller
  alias Ubg5.Bibles

  plug(:put_layout, "reader.html")

  def assign_js_and_css(conn) do
    conn
    |> assign(:scripts_js, File.read!("priv/static/js/scripts.js"))
    |> assign(:interlinear_link_css, File.read!("priv/static/css/interlinear-link.css"))
    |> assign(:style_css, File.read!("priv/static/css/style.css"))
  end

  def index(
        conn,
        %{
          "bible" => bible,
          "book_slug_name" => book_slug_name,
          "chapter_number" => chapter_number
        }
      ) do
    {chapter_number, _} = Integer.parse(chapter_number)

    case Bibles.find_chapter(bible, book_slug_name, chapter_number) do
      {:ok, bible_structure, book_structure, verses} ->
        conn
        |> Plug.Conn.fetch_query_params(conn)
        |> assign(:bible_structure, bible_structure)
        |> assign(:book_structure, book_structure)
        |> assign(:chapter_number, chapter_number)
        |> assign(:verses, verses)
        |> assign_js_and_css()
        |> assign(:prev_chapter_number, get_prev_chapter_number(chapter_number))
        |> assign(
          :next_chapter_number,
          get_next_chapter_number(chapter_number, book_structure["nof_chapters"])
        )
        |> assign(:show_chapters, Map.has_key?(conn.query_params, "chapters"))
        |> render()

      {:error, reason} ->
        raise reason
    end
  end

  def index(conn, %{}) do
    index(conn, %{
      "bible" => "ubg",
      "book_slug_name" => "rdz",
      "chapter_number" => "1"
    })
  end

  def get_prev_chapter_number(current_chapter_number) do
    cond do
      current_chapter_number <= 1 -> nil
      true -> current_chapter_number - 1
    end
  end

  def get_next_chapter_number(current_chapter_number, nof_chapters) do
    cond do
      current_chapter_number >= nof_chapters -> nil
      true -> current_chapter_number + 1
    end
  end
end
