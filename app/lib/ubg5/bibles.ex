defmodule Ubg5.Bibles do
  use Ubg5.CouchTesla

  plug Ubg5.TeslMwCouchDbName,  "bibles"
  
  # def get_db_name, do: "bibles"
  
  def init_db do
    ensure_doc("_design/query",
      %{
	views: %{
	  verses: %{
	    map: """
              function (doc) {
	        if (doc.type === 'verse') {
                  emit([doc.bible, doc.book_short_code, doc.chapter_number, doc.verse_number], doc.text)
                }
	      }
	    """,
	    reduce: "_count"
	  }
	}
      })
  end
    
  def get_verses(bible, book_short_code, chapter, verse_from, verse_to) do
    res = get!("/_design/query/_view/verses", query:
      %{
	reduce: false,
	startkey: Jason.encode!([bible, book_short_code, chapter, verse_from]),
	endkey: Jason.encode!([bible, book_short_code, chapter, verse_to])
      })
    Enum.map(res.body["rows"], fn(row) ->
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
