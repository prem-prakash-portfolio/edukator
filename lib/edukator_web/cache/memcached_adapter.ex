defmodule EdukatorWeb.Cache.MemcachedAdapter do
  @moduledoc """
  Memcachex API Adapter
  """

  defmodule Config do
    @moduledoc """
    Memcached Config
    """
    def config do
      servers = System.get_env("MEMCACHEDCLOUD_SERVERS") || "localhost:11211"
      server = servers |> String.split(",") |> List.first()
      [hostname, port] = String.split(server, ":")
      port = String.to_integer(port)

      config = [
        hostname: hostname,
        port: port,
        coder: Memcache.Coder.Erlang
      ]

      username = System.get_env("MEMCACHEDCLOUD_USERNAME")
      password = System.get_env("MEMCACHEDCLOUD_PASSWORD")

      if !is_nil(username) and !is_nil(password) do
        Keyword.merge(config, auth: {:plain, username, password})
      else
        config
      end
    end
  end

  defmodule MemcachedSupervisor do
    @moduledoc """
    Memcached Supervisor
    """
    use Supervisor

    def start_link(args) do
      Supervisor.start_link(__MODULE__, args, name: __MODULE__)
    end

    # Optional callback to do runtime configuration.
    def init(_args) do
      config = Config.config()
      children = [{Memcache, [config, [name: EdukatorWeb.MemcachedWorker]]}]

      Supervisor.init(children, strategy: :one_for_one)
    end
  end

  alias EdukatorWeb.MemcachedWorker

  def supervisor do
    MemcachedSupervisor
  end

  def get(key) do
    Memcache.get(MemcachedWorker, key)
  end

  def set(key, value) do
    Memcache.set(MemcachedWorker, key, value)
  end

  def delete(key) do
    Memcache.delete(MemcachedWorker, key)
  end

  def incr(key) do
    Memcache.incr(MemcachedWorker, key, default: 1, by: 1)
  end

  def flush do
    Memcache.flush(MemcachedWorker)
  end
end
