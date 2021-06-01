defmodule EdukatorWeb.ExternalLoginController do
  use EdukatorWeb, :controller

  alias Edukator.Accounts.Authentication

  @doc """
  Logs in user coming from Folha Dirigida.
  If user does not exist, it creates the user and send welcome notification

  It returns a URL (that points to other action of this controller: auth) with a token
  that the client should redirect to in order to get authenticated
  """
  def login(
        %{assigns: %{raw_current_tenant: tenant}} = conn,
        %{"chave" => external_login_access_key} = params
      ) do
    with true <- external_login_access_key == config_external_login_access_key(),
         user_attrs <- %{
           name: params["nome"],
           email: params["email"],
           account_type: params["account_type"],
           trial_expiration_date: params["trial_expire_date"]
         },
         {:ok, url} <- Authentication.ExternalToLocal.start_auth(user_attrs, tenant) do
      json(conn, %{url: url})
    else
      _ ->
        conn |> put_status(:not_found) |> json(%{})
    end
  end

  def login(conn, _params), do: conn |> put_status(:not_found) |> json(%{})

  def auth(%{assigns: %{raw_current_tenant: tenant}} = conn, %{"token" => raw_auth_token}) do
    case Authentication.ExternalToLocal.authorize_token(raw_auth_token, tenant) do
      {:ok, jwt} -> redirect(conn, to: "/e/#{jwt}")
      {:error, _} -> redirect(conn, to: "/")
    end
  end

  def auth(conn, _params), do: conn |> redirect(to: "/")

  defp config_external_login_access_key,
    do: :polymata |> Application.get_env(:external_login_client) |> Keyword.get(:login_token)
end
