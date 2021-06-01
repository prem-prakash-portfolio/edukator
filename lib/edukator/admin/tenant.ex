defmodule Edukator.Admin.Tenant do
  @moduledoc false
  alias Edukator.Admin.Campus
  alias Edukator.Repo

  def get_domain_from_tenant(tenant) do
    tenant
    |> get_campus_from_tenant()
    |> Map.get(:domain)
  end

  def get_campus_from_tenant(tenant) do
    Campus
    |> Repo.all()
    |> Enum.find(fn campus ->
      get_tenant_from_host(campus.domain) == tenant
    end)
  end

  def get_tenant_from_host(_host) do
    "public"
    # case Domainatrex.parse(host) do
    #   {:ok, %{domain: domain}} -> domain
    #   {:error, _} -> parse(host)
    # end
  end

  # defp parse(url) do
  #   case String.length(url) > 1 && String.contains?(url, ".") do
  #     true ->
  #       [_, domain] = url |> String.split(".") |> Enum.reverse()
  #       domain
  #
  #     _ ->
  #       raise RuntimeError, "Cannot parse: invalid domain"
  #       # {:error, "Cannot parse: invalid domain"}
  #   end
  # end
end
