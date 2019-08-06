defmodule Ubg5.CouchTesla do
  defmacro __using__(_) do
    quote do
      use Tesla

      plug Tesla.Middleware.BaseUrl, "http://localhost:5984"
      plug Tesla.Middleware.BasicAuth, username: "admin", password: "supersecret"
      plug Tesla.Middleware.JSON

      def ensure_ddoc(doc_id, doc_fields) do
	case get!("/" <> doc_id) do
	  %{status: 404} ->
	    full_doc = Map.put(doc_fields, :_id, doc_id)
	    case put!("/" <> doc_id, full_doc) do
	      %{status: 201} -> :ok
	      res -> throw res
	    end
	  %{status: 200, body: ddoc} ->
            if !ddocs_equal?(doc_fields, ddoc) do
              IO.puts("Recreating ddoc " <> doc_id)
              ddoc = %{ddoc | "views" => doc_fields["views"], "language" => doc_fields["language"]}
              case put!(doc_id, ddoc) do
                %{status: 201} -> :ok
                res -> throw res
              end
            end
	  res -> throw res
	end
      end

      defp ddocs_equal?(ddoc1, ddoc2) do
        views_equal = Map.equal?(ddoc1["views"], ddoc2["views"])
        lang_equal = ddoc1["language"] == ddoc2["language"]

        views_equal and lang_equal
      end
      
    end
  end
end
