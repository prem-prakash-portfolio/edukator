defmodule EdukatorWeb.Cache.ConCacheAdapter do
  @moduledoc """
  ConCache Adapter for SessionStore
  """

  defmodule ConCacheSupervisor do
    @moduledoc """
    ConCache Supervisor
    """
    use Supervisor

    def start_link(args) do
      Supervisor.start_link(__MODULE__, args, name: __MODULE__)
    end

    def init(_args) do
      children = [
        {ConCache, [name: :edukator_cache, ttl_check_interval: 1_000, global_ttl: :infinity]}
      ]

      Supervisor.init(children, strategy: :one_for_one)
    end
  end

  def supervisor do
    ConCacheSupervisor
  end

  def get(key) do
    value = ConCache.get(:edukator_cache, key)
    if is_nil(value), do: {:error, "Key not found"}, else: {:ok, value}
  end

  def set(key, value), do: ConCache.put(:edukator_cache, key, value)

  def delete(key), do: ConCache.delete(:edukator_cache, key)

  def incr(key) do
    ConCache.update(:edukator_cache, key, fn old_value ->
      {:ok, (old_value || 0) + 1}
    end)
  end
end
