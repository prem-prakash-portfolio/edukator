defmodule Edukator.Guardian do
  use Guardian, otp_app: :polymata

  alias Edukator.Accounts

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(%{"sub" => user_id, "tenant" => tenant}) do
    with {:ok, user} <- Accounts.get_user_by_id(user_id, tenant) do
      {:ok, user}
    else
      _ ->
        {:error, :resource_not_found}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :wrong_claim}
  end

  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
    with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
      {:ok, {old_token, old_claims}, {new_token, new_claims}}
    end
  end

  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end
end
