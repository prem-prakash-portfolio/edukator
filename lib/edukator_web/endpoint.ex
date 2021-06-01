defmodule EdukatorWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :edukator

  if Mix.env() == :prod do
    use Sentry.Phoenix.Endpoint
  end

  # socket "/socket", EdukatorWeb.UserSocket,
  #   websocket: true,
  #   longpoll: false

  plug EdukatorWeb.Tenant

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :edukator,
    gzip: true,
    only_matching:
      ~w(android apple css fonts img js browserconfig.xml favicon manifest.json robots.txt service-worker.js precache-manifest site.webmanifest)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  # plug Plug.Session, store: :cookie, key: "_edukator_key", signing_salt: "vl0BuB56"
  plug Plug.Session,
    store: EdukatorWeb.Plugs.SessionStore,
    key: "_edukator_key",
    expiration_in_seconds: 86_400 * 7,
    signing_salt: "i2Hwt9tl"

  plug EdukatorWeb.Router
end
