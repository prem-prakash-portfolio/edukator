defmodule Edukator.Admin.CDN do
  @moduledoc false
  alias Edukator.Admin.Tenant

  def get_cdn_image_url(tenant, path, expiry_in_seconds \\ 60_000, args \\ []) do
    distribution = %{
      CloudfrontSigner.Distribution.from_config(:polymata, :my_distribution)
      | domain: "https://content.#{Tenant.get_domain_from_tenant(tenant)}"
    }

    CloudfrontSigner.sign(distribution, path, args, expiry_in_seconds)
  end
end
