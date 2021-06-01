defmodule EdukatorWeb.Plugs.SessionStore do
  @moduledoc """
  Plug to provide session persistence over cache
  """

  @behaviour Plug.Session.Store
  @sid_bytes 32
  @cache_namespace nil

  @cache_adapter Application.get_env(:polymata, :cache_adapter)

  @doc """
  Initializes the store.
  The options returned from this function will be given
  to `get/3`, `put/4` and `delete/3`.
  """
  def init(options), do: options

  @doc """
  Parses the given cookie.
  Returns a session id and the session contents. The session id is any
  value that can be used to identify the session by the store.
  The session id may be nil in case the cookie does not identify any
  value in the store. The session contents must be a map.
  """
  def get(_conn, cookie, _options) do
    case @cache_adapter.get(namespace(cookie)) do
      {:ok, session} -> {cookie, session}
      _ -> {nil, %{}}
    end
  rescue
    _ -> {nil, %{}}
  end

  @doc """
  Stores the session associated with given session id.
  If `nil` is given as id, a new session id should be
  generated and returned.
  """
  def put(conn, nil, value, options) do
    sid =
      @sid_bytes
      |> :crypto.strong_rand_bytes()
      |> Base.encode16()
      |> String.downcase()

    put(conn, sid, value, options)
  end

  def put(_conn, sid, value, _options) do
    @cache_adapter.set(namespace(sid), value)
    sid
  end

  @doc """
  Removes the session associated with given session id from the store.
  """
  def delete(_conn, sid, _options) do
    @cache_adapter.delete(namespace(sid))
    :ok
  end

  defp namespace(key) do
    case @cache_namespace do
      nil -> key
      namespace -> "#{namespace}:#{key}"
    end
  end
end
