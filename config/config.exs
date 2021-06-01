# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :edukator,
  ecto_repos: [Edukator.Repo]

# Configures the endpoint
config :edukator, EdukatorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PKutswmfnNQbHOHjoXH/ZD85i7iv1HMDQdzcOqYWiGWe5jPfvbYDyvm2ldEHDoTf",
  render_errors: [view: EdukatorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Edukator.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :comeonin, :bcrypt_log_rounds, 11

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}]

config :edukator, :my_distribution,
  domain: "https://cloudfront.domain",
  key_pair_id: {:system, "AWS_CLOUDFRONT_KEY_PAIR_ID"},
  private_key: {:system, "AWS_CLOUDFRONT_PRIVATE_KEY"}

config :mime, :types, %{
  "application/x-zip-compressed" => ["zip"]
}

config :edukator, Edukator.Repo,
  migration_timestamps: [type: :utc_datetime, inserted_at: :created_at]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :edukator, Edukator.Repo,
  migration_timestamps: [type: :utc_datetime, inserted_at: :created_at]

config :triplex, repo: Edukator.Repo

config :edukator, EdukatorWeb.Gettext, default_locale: "pt_BR"

config :edukator, Edukator.Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  ttl: {30, :days},
  issuer: "questoes",
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: %{"k" => "MzqRvdASvS8qvU2yLBIkjQ", "kty" => "oct"},
  serializer: Edukator.Guardian

config :guardian, Guardian.DB,
  repo: Edukator.Repo,
  schema_name: "guardian_tokens",
  sweep_interval: 60

## Sentry
config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  environment_name: :prod,
  included_environments: [:prod],
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
import_config "#{Mix.env()}.mailer.exs"
