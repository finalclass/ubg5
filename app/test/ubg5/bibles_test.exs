defmodule Ubg5.BiblesTest do
  use ExUnit.Case

  import Tesla.Mock

  setup do
    mock fn
      %{method: :get, url: "http://localhost:5984/bibles/"} ->
        %Tesla.Env{status: 200, body: "hello"}
      %{method: :get, url: "http://localhost:5984/bibles/_design/query/_view/verses"} ->
	%Tesla.Env{status: 200, body: """
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
        """}
    end

    :ok
  end

  test "get verse" do
    verses = Ubg5.Bibles.get_verses("ubg", "gen", 1, 1, 2)
    assert is_list(verses)
    assert length(verses) == 2
    first_verse = List.first(verses)
    last_verse = List.last(verses)
    assert first_verse.text == "Na początku Bóg stworzył niebo i ziemię."
    assert first_verse.bible == "ubg"
    assert first_verse.book_short_code == "gen"
    assert first_verse.chapter_number == 1
    assert first_verse.verse_number == 1
    
    assert last_verse.text == "A ziemia była bezkształtna i pusta i ciemność była nad głębią, a Duch Boży unosił się nad wodami."
  end
end
