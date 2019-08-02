defmodule Ubg5.TeslMwCouchDbName do
  @behaviour Tesla.Middleware

  def call(env, next, db_name) do
    url_split = String.split(env.url, "/")
    url_split_with_db_name = List.insert_at(url_split, 3, db_name)
    env = %{env | url: Enum.join(url_split_with_db_name, "/")}
    Tesla.run(env, next)
  end
end
