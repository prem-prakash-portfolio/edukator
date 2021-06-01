defmodule Edukator.MixProject do
  use Mix.Project

  def project do
    [
      app: :polymata,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Edukator.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.9"},
      {:phoenix_pubsub, "~> 1.1.2"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:exnumerator, "~> 1.7.3"},
      {:timex, "~> 3.6.1"},
      {:brcpfcnpj, "~> 0.2.0"},
      {:absinthe, "~> 1.4.0"},
      {:absinthe_plug, "~> 1.4"},
      {:dataloader, "~> 1.0"},
      {:delirium_tremex, "~> 1.0.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:triplex, "~> 1.3.0"},
      {:domainatrex, "~> 2.2.0"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:ex_aws_ses, "~> 2.0"},
      {:cloudfront_signer, "~> 0.1.0"},
      {:hackney, "~> 1.9"},
      {:inflex, "~> 2.0.0"},
      {:swoosh, "~> 0.23"},
      {:gen_smtp, "~> 0.13"},
      {:phoenix_swoosh, "~> 0.2"},
      {:cursor_paginator, "~> 0.6.1"},
      {:memcachex, "~> 0.4"},
      {:con_cache, "~> 0.13"},
      {:sentry, "~> 7.0"},
      {:guardian, "~> 1.2"},
      {:guardian_db, "~> 2.0"},
      {:solid, "~> 0.3.0"},
      {:premailex, "~> 0.3.0"},
      {:quantum, "~> 2.3"}
    ] ++ dev_deps() ++ test_deps()
  end

  defp dev_deps do
    [
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp test_deps do
    [
      {:ex_machina, "~> 2.3", only: :test},
      {:excoveralls, "~> 0.10", only: :test},
      {:mox, "~> 0.5.0", only: :test},
      {:bypass, "~> 1.0", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.load", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.migrate": ["ecto.migrate", "ecto.dump"],
      # "triplex.migrate": ["triplex.migrate", "ecto.dump"],
      "ecto.rollback": ["ecto.rollback", "ecto.dump"],
      setup_test: [
        "ecto.drop",
        "ecto.create",
        "ecto.load",
        "ecto.migrate --migrations-path=priv/repo/tenant_migrations",
        "test"
      ],
      test: ["ecto.drop", "ecto.create --quiet", "ecto.load", "test"],
      compile: ["compile --warnings-as-errors"],
      sentry_recompile: ["compile", "deps.compile sentry --force"]
    ]
  end
end
