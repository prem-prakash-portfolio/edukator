defmodule Edukator.Accounts.Passwords do
  @moduledoc """
  This module has methods to deal with tokens related to passwords
  """

  @reset_password_token_ttl 86_400

  import EdukatorWeb.Gettext, only: [gettext: 1]

  alias Edukator.Repo
  alias Edukator.Accounts.User
  alias Edukator.Mailer
  alias Edukator.Mailer.AccountsMailer
  alias Edukator.TokenGenerator

  def send_reset_password_instructions(%User{} = user, tenant \\ "public") do
    {raw, enc} = TokenGenerator.generate("reset_password_token")

    user
    |> User.password_reset_changeset(enc)
    |> Repo.update!(prefix: tenant)
    |> AccountsMailer.reset_password_instructions(raw, tenant)
    |> Mailer.deliver()
  end

  def reset_password_by_token(token, password, password_confirmation, tenant \\ "public") do
    reset_password_token = TokenGenerator.digest("reset_password_token", token)
    user = Repo.get_by(User, [reset_password_token: reset_password_token], prefix: tenant)

    case user do
      %User{} = user -> maybe_reset_password(user, password, password_confirmation, tenant)
      nil -> {:error, gettext("could not find user")}
    end
  end

  defp maybe_reset_password(%User{} = user, password, password_confirmation, tenant) do
    if reset_password_period_valid?(user.reset_password_sent_at) do
      user
      |> User.update_user_changeset(%{
        password: password,
        password_confirmation: password_confirmation
      })
      |> Repo.update(prefix: tenant)
    else
      {:error, gettext("token expired")}
    end
  end

  defp reset_password_period_valid?(sent_at) when is_nil(sent_at), do: false

  defp reset_password_period_valid?(%NaiveDateTime{} = sent_at) do
    DateTime.diff(DateTime.utc_now(), sent_at, :second) < @reset_password_token_ttl
  end
end
