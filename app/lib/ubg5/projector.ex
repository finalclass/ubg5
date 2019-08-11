defmodule Ubg5.Projector do
  use GenServer
  alias Ubg5.Bibles

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end
  
  def get_verse(proj_id) do
    GenServer.call(__MODULE__, {:get_verse, proj_id})
  end

  def set_verse(proj_id, bible, book_name, chapter_number, verse_number) do
    GenServer.cast(__MODULE__, {:set_verse, proj_id, bible, book_name, chapter_number, verse_number})
  end

  ## Defining GenServer Callbacks
  
  @impl true
  def handle_call({:get_verse, proj_id}, _from, state) do
    result = case Map.fetch(state, proj_id) do
               :error -> nil
               {:ok, value} -> value
             end
    IO.inspect(state)
    IO.inspect(%{result: result})
    {:reply, result, state}
  end

  @impl true
  def handle_cast({:set_verse, proj_id, bible, book_name, chapter_number, verse_number}, state) do
    IO.inspect({bible, book_name, chapter_number, verse_number})
    verse = Bibles.get_verses(bible, book_name, chapter_number, verse_number, verse_number)
    |> List.first()

    state = Map.put(state, proj_id, verse)
    IO.inspect(state)
    {:noreply, state}
  end
  
end
