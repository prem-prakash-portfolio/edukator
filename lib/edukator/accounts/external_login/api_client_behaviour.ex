defmodule Edukator.Accounts.ExternalLogin.ApiClientBehaviour do
  @moduledoc false
  @callback login(String.t(), String.t()) :: tuple()
end
