defmodule Ubg5Web.Router do
  use Ubg5Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end
  
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Ubg5Web do
    pipe_through :api
  end

  scope "/", Ubg5Web do
    pipe_through :browser
    
    get "/", ReaderController, :index
    get "/:bible/:book_slug_name/:chapter_number/", ReaderController, :index
  end
end
