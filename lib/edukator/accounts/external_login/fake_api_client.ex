defmodule Edukator.Accounts.ExternalLogin.FakeApiClient do
  @moduledoc false
  @behaviour Edukator.Accounts.ExternalLogin.ApiClientBehaviour

  def login("failed_auth", _password), do: {:error, "cant login"}
  def login(email, _password), do: {:ok, %{:name => "Fulano", :email => email, :account_type => "FULL"}}
end
