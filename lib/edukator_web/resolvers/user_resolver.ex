defmodule EdukatorWeb.Resolvers.UserResolver do
  @moduledoc false
  alias Edukator.Accounts
  alias Edukator.Accounts.Authentication
  alias Edukator.Guardian
  # alias Edukator.Mailer
  # alias Edukator.Mailer.AccountsMailer

  import EdukatorWeb.ErrorHelpers, only: [translate_error: 1]

  @spec current_user(any, any, any) :: {:ok, any}
  def current_user(_parent, _args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def current_user(_parent, _args, _resolutions) do
    {:ok, nil}
  end

  def update(_parent, args, %{context: %{current_user: current_user, tenant: tenant}}) do
    Accounts.update_user(current_user, args, tenant)
  end

  def update_password(_parent, args, %{context: %{current_user: current_user, tenant: tenant}}) do
    case Accounts.update_password(current_user, args, tenant) do
      {:ok, user} ->
        {:ok, user}

      {:error, changeset} ->
        errors =
          changeset
          |> Ecto.Changeset.traverse_errors(&translate_error/1)
          |> Enum.map(fn {k, v} ->
            %{key: k, messages: v}
          end)

        {:error, errors}
    end
  end

  def update_password(_parent, _args, _context) do
    {:error, %{key: "auth", messages: "Unauthenticated"}}
  end

  # def signup(_parent, args, %{context: %{tenant: tenant}}) do
  #   case Accounts.create(args, tenant) do
  #     {:ok, user} ->
  #       user |> AccountsMailer.new_account_welcome_message(tenant) |> Mailer.deliver()
  #       {:ok, user}

  #     {:error, changeset} ->
  #       errors =
  #         changeset
  #         |> Ecto.Changeset.traverse_errors(&translate_error/1)
  #         |> Enum.map(fn {k, v} ->
  #           %{key: k, messages: v}
  #         end)

  #       {:error, errors}
  #   end
  # end

  def authenticate(_parent, args, %{context: %{tenant: tenant}}) do
    with {:ok, user} <- Authentication.LocalToExternal.authenticate(args, tenant),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user, %{"tenant" => tenant}) do
      user = Map.put(user, :token, token)
      {:ok, user}
    else
      {:error, error} -> {:error, error}
    end
  end

  def logout(_parent, _args, %{
        context: %{current_user: _current_user, token: token}
      }) do
    {:ok, _claims} = Guardian.revoke(token)
    {:ok, "logged out"}
  end

  def logout(_parent, _args, _context) do
    {:ok, "logged out"}
  end
end
