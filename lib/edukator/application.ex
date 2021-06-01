defmodule Edukator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Edukator.Repo,
      # Start the endpoint when the application starts
      EdukatorWeb.Endpoint,
      # Starts a worker by calling: Edukator.Worker.start_link(arg)
      # {Edukator.Worker, arg},

      # Cache Supervisor
      EdukatorWeb.Cache.CacheSupervisor,
      # Remove expired tokens
      {Guardian.DB.Token.SweeperServer, []}
    ]

    children =
      if Application.get_env(:edukator, :scheduler_enabled) do
        children ++ [{Edukator.Scheduler, []}]
      else
        children
      end

    :ets.new(:session, [:named_table, :public, read_concurrency: true])

    # Sentry Capture Crashed Process Exceptions
    if Mix.env() == :prod do
      {:ok, _} = Logger.add_backend(Sentry.LoggerBackend)
      Logger.configure_backend(Sentry.LoggerBackend, include_logger_metadata: true)
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Edukator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EdukatorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
