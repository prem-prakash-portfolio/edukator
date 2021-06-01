import Config

# Configure your database
config :edukator, Edukator.Repo,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: System.get_env("POSTGRES_DB") || "edukator_test",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  migration_source: "elixir_schema_migrations"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :edukator, EdukatorWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# cache
config :edukator, :cache_adapter, EdukatorWeb.Cache.ConCacheAdapter

# external login
config :edukator, :external_login_client, api_client: ExternalLoginApiClientBehaviourMock

# disable scheduler
config :edukator, :scheduler_enabled, false
