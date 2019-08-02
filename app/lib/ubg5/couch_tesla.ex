defmodule Ubg5.CouchTesla do
  defmacro __using__(_) do
    quote do
      use Tesla

      plug Tesla.Middleware.BaseUrl, "http://localhost:5984"
      plug Tesla.Middleware.BasicAuth, username: "admin", password: "supersecret"
      plug Tesla.Middleware.JSON

      def ensure_doc(doc_id, doc_fields) do
	case get!("/" <> doc_id) do
	  %{status: 404} ->
	    full_doc = Map.put(doc_fields, :_id, doc_id)
	    case put!("/" <> doc_id, full_doc) do
	      %{status: 201} -> :ok
	      res -> throw res
	    end
	  %{status: 200} -> :ok
	  res -> throw res
	end
      end

    end
  end
end
