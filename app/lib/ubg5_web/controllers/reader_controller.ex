defmodule Ubg5Web.ReaderController do
  use Ubg5Web, :controller

  plug :put_layout, "reader.html"

  def assign_js_and_css(conn) do
    conn
# |> assign(:scripts_js, File.read!("priv/static/js/scripts.js"))
    |> assign(:scripts_js, "alert('ok')")
    |> assign(:interlinear_link_css, File.read!("priv/static/css/interlinear-link.css"))
    |> assign(:style_css, File.read!("priv/static/css/style.css"))
  end
  
  def index(conn, %{}) do
    conn
    |> assign(:book_short_name, "Rdz")
    |> assign(:chapter_number, 1)
    |> assign(:show_chapters, false)
    |> assign(:book_chapters_numbers, [1, 2])
    |> assign(:encoded_book_name, "rdz")
    |> assign(:book_name, "Rodzaju")
    |> assign(:book_oblubienica_index, "rdz")
    |> assign(:book_biblehub_name, "gen")
    |> assign(:prev_chapter_number, nil)
    |> assign(:next_chapter_number, 2)
    |> assign_js_and_css()
    |> assign(:verses, [
          %{
            number: 1,
            text: "Na początku Bóg stworzył niebo i ziemie"
          },
          %{
            number: 2,
            text: "A ziemia była pustkowiem i ciemność była nad otchłanią"
          }
        ])
    |> assign(:books, [
          %{
            short_code: "gen",
            encoded_name: "rdz",
            short_name: "Rdz",
            full_name: "Rodzaju",
            nof_chapters: 42
          }
        ])
    |> render()
  end
end
