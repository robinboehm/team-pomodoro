defmodule PlatformWeb.Router do
  use PlatformWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlatformWeb.UserNamePlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :basic_auth do
    if Mix.env == :prod do
      plug PlatformWeb.BasicAuthPlug, username: "timer", password: "timer"
    end
  end

  scope "/", PlatformWeb do
    pipe_through [:browser, :basic_auth] # Use the default browser stack

    get "/", PageController, :index

    resources "/user", UserController, singleton: true
    resources "/rooms", RoomController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlatformWeb do
  #   pipe_through :api
  # end
end
