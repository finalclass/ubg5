defmodule Ubg5.Bibles do
  use Ubg5.CouchTesla

  plug(Ubg5.TeslMwCouchDbName, "bibles")

  # def get_db_name, do: "bibles"

  def init_db do
    ensure_ddoc(
      "_design/query",
      %{
        "language" => "erlang",
        "views" => %{
          "structure" => %{
            "map" => """
            fun({Doc}) ->
              Type = couch_util:get_value(<<"type">>, Doc),
              
              case Type of
                <<"structure">> ->
                  ShortCode = couch_util:get_value(<<"short_code">>, Doc),
                  Emit(ShortCode, {Doc});
                _ -> ok
              end
            end.            
            """
          },
          "verses" => %{
            "map" => """
            fun({Doc}) ->
              Type = couch_util:get_value(<<"type">>, Doc),
              
              case Type of
                <<"verse">> ->
                  BibleShortCode = couch_util:get_value(<<"bible_short_code">>, Doc),
                  BookShortCode = couch_util:get_value(<<"book_short_code">>, Doc),
                  ChapterNumber = couch_util:get_value(<<"chapter_number">>, Doc),
                  VerseNumber = couch_util:get_value(<<"verse_number">>, Doc),
                  VerseText = couch_util:get_value(<<"text">>, Doc),
                  Emit([BibleShortCode, BookShortCode, ChapterNumber, VerseNumber], VerseText);
                _ -> ok
              end
            end.
            """,
            "reduce" => "_count"
          }
        }
      }
    )
  end

  def find_chapter(bible_short_code, book_slug_name, chapter_number) do
    case get_structure(bible_short_code) do
      {:error, _} ->
        {:error, :missing_bible}

      {:ok, structure} ->
        case get_book_info_by_slug(structure, book_slug_name) do
          nil ->
            {:error, :missing_book}

          book_structure ->
            case chapter_number > book_structure["nof_chapters"] or chapter_number < 1 do
              true ->
                {:error, :missing_chapter}

              false ->
                verses =
                  get_verses(
                    bible_short_code,
                    book_structure["short_code"],
                    chapter_number,
                    1,
                    %{}
                  )

                {:ok, structure, book_structure, verses}
            end
        end
    end
  end

  def get_structure(bible) do
    res = get!("/_design/query/_view/structure", query: %{key: Jason.encode!(bible)})

    case res do
      %{status: 200, body: result} ->
        case length(result["rows"]) do
          0 -> {:error, "bible structure does not exists"}
          _ -> {:ok, List.first(result["rows"])["value"]}
        end

      res ->
        {:error, res.body}
    end
  end

  def get_book_info_by_slug(structure, book_slug_name) do
    Enum.find(structure["books"], fn book ->
      book["slug_name"] == book_slug_name
    end)
  end

  def get_book_info_by_short_code(structure, book_short_code) do
    Enum.find(structure["books"], fn book ->
      book["short_code"] == book_short_code
    end)
  end

  def get_verses(bible, book_short_code, chapter, verse_from, verse_to) do
    res =
      get!("/_design/query/_view/verses",
        query: %{
          reduce: false,
          startkey: Jason.encode!([bible, book_short_code, chapter, verse_from]),
          endkey: Jason.encode!([bible, book_short_code, chapter, verse_to])
        }
      )

    Enum.map(res.body["rows"], fn row ->
      [bible, book_short_code, chapter_number, verse_number] = row["key"]

      %{
        _id: row["id"],
        bible: bible,
        book_short_code: book_short_code,
        chapter_number: chapter_number,
        verse_number: verse_number,
        text: row["value"]
      }
    end)
  end
end
