defmodule EdukatorWeb.Cache.CacheSupervisor do
  @moduledoc """
  Memcached Supervisor
  """

  def child_spec(_arg) do
    supervisor = Application.get_env(:polymata, :cache_adapter).supervisor

    %{
      id: supervisor,
      start: {supervisor, :start_link, [[]]}
    }
  end
end
