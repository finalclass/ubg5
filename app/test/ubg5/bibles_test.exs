defmodule Ubg5.BiblesTest do
  use ExUnit.Case
  alias Ubg5.Bibles

  import Tesla.Mock

  setup do
    mock(fn
      %{method: :get, url: "http://localhost:5984/bibles/"} ->
        %Tesla.Env{status: 200, body: "hello"}

      %{method: :get, url: "http://localhost:5984/bibles/_design/query/_view/verses"} ->
        %Tesla.Env{
          status: 200,
          body: """
              "rows": [
                  {
                      "id": "verse-id-1",
                      "key": ["ubg", "gen", 1, 1]
                      "value": "Na początku Bóg stworzył niebo i ziemię."
                  },
                  {
                      "id": "verse-id-2",
                      "key": ["ubg", "gen", 1, 2]
                      "value": "A ziemia była bezkształtna i pusta i ciemność była nad głębią, a Duch Boży unosił się nad wodami."
                  }
              ]
          """
        }
    end)

    :ok
  end

  @tag only: false
  test "find_chapter finds chapter with book_structure and bible name" do
    {:ok, bible_short_code, book_structure, verses} = Bibles.find_chapter("ubg", "rdz", 1)
    assert book_structure != nil
    assert is_map(book_structure)
    assert book_structure["short_name"] == "Rdz"
    assert bible_short_code == "ubg"
    assert length(verses) > 0
  end

  @tag only: false
  test "find_chapter returns :error if bible_short_code parameter is missing" do
    ret = Bibles.find_chapter("invalid", "rdz", 1)
    assert ret == {:error, :missing_bible}
  end

  @tag only: false
  test "find_chapter returns :error if book is missing" do
    ret = Bibles.find_chapter("ubg", "invalid", 1)
    assert ret == {:error, :missing_book}
  end

  @tag only: false
  test "find_chapter returns :error if chapter is missing" do
    ret = Bibles.find_chapter("ubg", "rdz", 100)
    assert ret == {:error, :missing_chapter}
  end

  @tag only: false
  test "get verse" do
    verses = Bibles.get_verses("ubg", "gen", 1, 1, 2)
    assert is_list(verses)
    assert length(verses) == 2
    first_verse = List.first(verses)
    last_verse = List.last(verses)
    assert first_verse.text == "Na początku Bóg stworzył niebo i ziemię."
    assert first_verse.bible == "ubg"
    assert first_verse.book_short_code == "gen"
    assert first_verse.chapter_number == 1
    assert first_verse.verse_number == 1

    assert last_verse.text ==
             "A ziemia była bezkształtna i pusta i ciemność była nad głębią, a Duch Boży unosił się nad wodami."
  end
end
