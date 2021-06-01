defmodule EdukatorWeb.AuthHelper do
  @moduledoc """
  Module with methods to help the authentication process on tests.
  """
  import Edukator.Factory
  import Plug.Conn, only: [put_req_header: 3]
  alias Edukator.Guardian

  defmacro __using__(_) do
    quote do
      import EdukatorWeb.AuthHelper
    end
  end

  def authenticate(conn, user = %{id: _} \\ insert(:user)) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user, %{"tenant" => "public"})
    put_req_header(conn, "authorization", "Bearer #{token}")
  end
end
