defmodule Importer do
  require IEx
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://localhost:5984/" <> get_db_name())
  plug(Tesla.Middleware.BasicAuth, username: "admin", password: "supersecret")
  plug(Tesla.Middleware.JSON)

  def get_db_name do
    System.get_env("DB_NAME") || "bibles"
  end

  def create_db do
    res = get!("/")

    case res.status do
      404 ->
        res2 = put!("/", "")

        case res2.status do
          201 -> :ok
          _ -> throw("Database creation error")
        end

      _ ->
        throw("Database already exists")
    end
  end

  def main(file_path) do
    delete!("/")
    :ok = create_db()
    bible = import_bible(file_path)

    walk_verses(bible, fn verse ->
      post!("/", verse)
    end)

    structure = generate_structure(bible)
    post!("/", structure)
  end

  def generate_structure(bible) do
    books =
      Enum.map(Enum.with_index(bible.value), fn {book, index} ->
        %{
          index: index + 1,
          short_code: book.attr.uu,
          full_name: book.attr.n,
          short_name: book.attr.s,
          slug_name: book.attr.u,
          nof_chapters: length(book.value),
          biblehub_book_name: Map.get(book.attr, :otn),
          oblubienica_book_name: Map.get(book.attr, :nti)
        }
      end)

    %{
      type: "structure",
      short_code: "ubg",
      books: books
    }
  end

  def walk_verses(bible, fun) do
    Enum.each(bible.value, fn book ->
      IO.puts(book.attr.n)

      Enum.each(book.value, fn chapter ->
        IO.puts(chapter.attr.n)

        Enum.each(chapter.value, fn verse ->
          fun.(%{
            bible_short_code: "ubg",
            type: "verse",
            book_short_code: book.attr.uu,
            chapter_number: elem(Integer.parse(chapter.attr.n), 0),
            verse_number: elem(Integer.parse(verse.attr.n), 0),
            text: List.first(verse.value)
          })
        end)
      end)
    end)
  end

  def import_bible(file_path) do
    File.read!(file_path)
    |> Quinn.parse(%{map_attributes: true})
    |> List.first()
  end
end
