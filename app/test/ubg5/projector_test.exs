defmodule Ubg5.ProjectorTest do
  use ExUnit.Case
  alias Ubg5.Projector

  import Tesla.Mock

  setup do
    mock fn
      %{method: :get, url: "http://localhost:5984/bibles/"} ->
        %Tesla.Env{status: 200, body: "hello"}
      %{method: :get, url: "http://localhost:5984/bibles/_design/query/_view/structure"} ->
        %Tesla.Env{status: 200, body: """
        {
            "rows": [
                "id": "structure-id-1",
                "key": "ubg",
                "value": {
                    "_id": "structure-id-1",
                    "_rev": "1-3b42e27c2cfc5c67546903bf743d7e4e",
                    "bible": "ubg",
                    "books": [
                        {
                            "biblehub_book_name": "genesis",
                            "full_name": "Ks. Rodzaju",
                            "index": 1,
                            "nof_chapters": 50,
                            "oblubienica_book_name": null,
                            "short_code": "gen",
                            "short_name": "Rdz",
                            "slug_name": "rdz"
                        }
                    ]
                }
            ]
        }
        """}
      %{method: :get, url: "http://localhost:5984/bibles/_design/query/_view/verses"} ->
	%Tesla.Env{status: 200, body: """
        {
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
        }
        """}
    end

    :ok
  end

  test "set projector id" do
    Projector.set_verse("abc", "ubg", "gen", 1, 1)
    verse = Projector.get_verse("abc")
    assert verse.book != nil
    assert verse.book["short_name"] == "Rdz"
  end
end
