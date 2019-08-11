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
  def init(init_arg) do
    {:ok, init_arg}
  end
  
  @impl true
  def handle_call({:get_verse, proj_id}, _from, state) do
    result = case Map.fetch(state, proj_id) do
               :error -> nil
               {:ok, value} -> value
             end
    {:reply, result, state}
  end

  @impl true
  def handle_cast({:set_verse, proj_id, bible, book_name, chapter_number, verse_number}, state) do
    verse = Bibles.get_verses(bible, book_name, chapter_number, verse_number, verse_number)
    |> List.first()

    structure = Bibles.get_structure(bible)
    book = Bibles.get_book_info_by_short_code(structure, verse.book_short_code)
    verse = Map.put(verse, :book, book)
    
    state = Map.put(state, proj_id, verse)
    {:noreply, state}
  end
  
end
