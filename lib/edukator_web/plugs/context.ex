defmodule EdukatorWeb.Context do
  @moduledoc false
  @behaviour Plug
  import Plug.Conn, only: [get_req_header: 2]
  alias Edukator.Guardian

  def init(opts), do: opts

  def call(%{assigns: %{raw_current_tenant: tenant}} = conn, _) do
    context = build_context(conn, tenant)

    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn, tenant) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user, _claims} <- Guardian.resource_from_token(token) do
      if Mix.env() == :prod do
        Sentry.Context.set_user_context(user)
      end

      %{current_user: user, token: token}
    else
      _ -> %{}
    end
    |> Map.put(:tenant, tenant)
  end
end
