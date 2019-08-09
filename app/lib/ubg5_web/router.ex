defmodule Ubg5Web.Router do
  use Ubg5Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end
  
  pipeline :projector do
    plug :accepts, ["text"]
  end

  scope "/projector" do
    pipe_through :projector

    post "/", ProjectorController, :set_verse
  end
  
  scope "/", Ubg5Web do
    pipe_through :browser
    
    get "/", ReaderController, :index
    get "/:bible/:book_slug_name/:chapter_number/", ReaderController, :index
    get "/projector", ProjectorController, :index
  end
end
