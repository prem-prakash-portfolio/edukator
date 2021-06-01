if Code.ensure_loaded?(Plug) do
  defmodule EdukatorWeb.Tenant do
    @moduledoc """
    This is a basic plug that loads the current tenant assign from a given
    value set on subdomain.

    To plug it on your router, you can use:

        plug EdukatorWeb.TriplexElevator,
          tenant_handler: &TenantHelper.tenant_handler/1

    See `EdukatorWeb.TriplexElevator.Config` to check all the allowed `config` flags.
    """

    defmodule Config do
      @moduledoc """
      This is a struct that holds the configuration for `Triplex.SubdomainPlug`.
      Here are the config keys allowed:
      - `tenant_handler`: function to handle the tenant param. Its return will
      be used as the tenant.
      - `assign`: the name of the assign where we must save the tenant.
      - `endpoint`: the Phoenix.Endpoint to get the host name to dicover the
      subdomain.
      """

      defstruct [
        :tenant_handler,
        assign: :current_tenant
      ]
    end

    alias Triplex.Plug
    alias Edukator.Admin.Tenant

    @doc false
    def init(opts), do: struct(Config, opts)

    @doc false
    def call(%{host: host} = conn, config) do
      Plug.put_tenant(conn, Tenant.get_tenant_from_host(host), config)
    end
  end
end
