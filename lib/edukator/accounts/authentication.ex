defmodule Edukator.Accounts.Authentication do
  @moduledoc false
  defmodule ExternalToLocal do
    @moduledoc """
    Authenticates user when login is started on Folha Dirigida side
    """
    alias Edukator.Accounts
    alias Edukator.Notifications.NotificationSender
    alias Edukator.TokenGenerator
    alias Edukator.Guardian
    alias EdukatorWeb.Router.Helpers, as: Routes

    def start_auth(%{email: email} = user_attrs, tenant \\ "public") do
      with :ok <- Accounts.validate_trial_expiration_date(user_attrs) do
        user_attrs = Map.put(user_attrs, :email, downcase_and_trim(email))

        user =
          case Accounts.get_user_by_email(email, tenant) do
            {:ok, user} -> user
            {:error, _} -> create_and_welcome_user(user_attrs, tenant)
          end

        {raw_auth_token, encrypted_auth_token} = TokenGenerator.generate("auth_token")
        Accounts.update_auth_token!(user, encrypted_auth_token, tenant)
        {:ok, generate_auth_url(raw_auth_token)}
      else
        _ ->
          {:ok, System.get_env("TRIAL_EXPIRED_URL")}
      end
    end

    defp downcase_and_trim(email) do
      email |> String.downcase() |> String.replace(~r/\s+/, "") |> String.trim()
    end

    defp create_and_welcome_user(user_attrs, tenant) do
      user = Accounts.create!(user_attrs, tenant)
      NotificationSender.maybe_send(user, "welcome_message", %{user: user})
      user
    end

    defp generate_auth_url(token),
      do: Routes.external_login_url(EdukatorWeb.Endpoint, :auth, %{token: token})

    def authorize_token(raw_auth_token, tenant) do
      with encrypted_auth_token <- TokenGenerator.digest("auth_token", raw_auth_token),
           user <- Accounts.get_user_by!([auth_token: encrypted_auth_token], tenant),
           user <- Accounts.update_auth_token!(user, nil, tenant),
           {:ok, jwt, _claims} <- Guardian.encode_and_sign(user, %{"tenant" => tenant}) do
        {:ok, jwt}
      else
        _ ->
          {:error, :auth_error}
      end
    end
  end

  defmodule LocalToExternal do
    @moduledoc """
    Authenticates user when login is started on this application
    """
    alias Bcrypt
    alias Edukator.Accounts

    def authenticate(%{email: email, password: password} = _args, tenant \\ "public") do
      email = email |> String.downcase() |> String.trim()

      with {:ok, user_attrs} <- external_login_api_client().login(email, password),
           :ok <- Accounts.validate_trial_expiration_date(user_attrs) do
        user_attrs =
          user_attrs
          |> Map.put(:last_sign_in_at, DateTime.utc_now())
          |> Map.put(:password, password)

        Accounts.update_or_create_user(user_attrs, tenant)
      else
        {:error, :trial_expired} ->
          {:error, %{key: "email", messages: "Seu período de avaliação terminou, assine agora!"}}

        {:error, error} ->
          {:error, error}
      end
    end

    defp external_login_api_client,
      do: :edukator |> Application.get_env(:external_login_client) |> Keyword.get(:api_client)
  end
end
