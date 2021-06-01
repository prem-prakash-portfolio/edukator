defmodule Edukator.Accounts.ExternalLogin.ApiClientTest do
  use EdukatorWeb.ConnCase

  setup %{conn: conn} do
    bypass = Bypass.open()

    {:ok, conn: conn, bypass: bypass}
  end

  test "a sent email results in :ok", %{conn: conn, bypass: bypass} do
    Application.put_env(:polymata, :external_login_client,
      api_client: Edukator.Accounts.ExternalLogin.ApiClient,
      base_url: endpoint_url(bypass.port)
    )

    user = %{
      name: "Fulano de Tal",
      email: "fulano@tal.com.br",
      password: "senha123"
    }

    query = """
    mutation authenticate {
      authenticate(email: "#{user.email}" password: "#{user.password}") {
        id,
        name,
        email
      }
    }
    """

    response_body = """
        {
          "email": "#{user.email}",
          "name": "garagem PRem",
          "account_type": "FULL",
          "trial_expire_date": "2020-10-25"
        }
    """

    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      Plug.Conn.resp(conn, 200, response_body)
    end)

    res =
      conn
      |> post("/api/graphql", %{query: query})
      |> json_response(200)

    assert res["data"]["authenticate"]["email"] == user.email
  end

  defp endpoint_url(port), do: "http://localhost:#{port}/"
end
