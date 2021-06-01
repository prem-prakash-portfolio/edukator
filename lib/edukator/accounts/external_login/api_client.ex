defmodule Edukator.Accounts.ExternalLogin.ApiClient do
  @moduledoc """
  Authenticates an user on external service
  """

  @behaviour Edukator.Accounts.ExternalLogin.ApiClientBehaviour

  defp token, do: :edukator |> Application.get_env(:external_login_client) |> Keyword.get(:token)

  def base_url,
    do: :edukator |> Application.get_env(:external_login_client) |> Keyword.get(:base_url)

  def login(email, password) do
    req_body =
      {:form,
       Map.to_list(%{
         token: token(),
         email: email,
         password: password
       })}

    {:ok, 200, _headers, client_ref} = :hackney.post(base_url(), [], req_body)
    {:ok, body} = :hackney.body(client_ref)

    case Jason.decode(body) do
      {:ok, params} ->
        {:ok,
         %{
           name: params["name"],
           email: params["email"],
           account_type: params["account_type"],
           trial_expiration_date: params["trial_expire_date"]
         }}

      _ ->
        {:error, %{key: "email", messages: "Email ou senha inválidos"}}
    end
  end
end
