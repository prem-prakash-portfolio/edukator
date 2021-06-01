defmodule EdukatorWeb.Router do
  use EdukatorWeb, :router
  use Plug.ErrorHandler

  if Mix.env() == :prod do
    use Sentry.Plug
  end

  pipeline :api do
    plug EdukatorWeb.Context
    plug :accepts, ["json"]
  end

  pipeline :gzip do
    plug PlugContrib.Gzip
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/api" do
    pipe_through [:api, :gzip]

    forward "/graphql",
            Absinthe.Plug,
            schema: EdukatorWeb.Schema

    if Mix.env() == :dev do
      # For the GraphiQL interactive interface, a must-have for happy frontend devs.
      forward "/graphiql",
              Absinthe.Plug.GraphiQL,
              schema: EdukatorWeb.Schema,
              interface: :advanced
    end
  end

  scope "/", EdukatorWeb do
    post "/api/events", EventsController, :create
    post "/login", ExternalLoginController, :login
  end

  scope "/", EdukatorWeb do
    pipe_through :browser

    get "/auth", ExternalLoginController, :auth
    get "/", AppController, :index
    get("/*path", AppController, :index)
  end
end
