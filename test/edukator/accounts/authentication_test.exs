defmodule Edukator.Accounts.AuthenticationTest do
  use EdukatorWeb.ConnCase

  setup do
    bypass = Bypass.open()

    Application.put_env(:polymata, :external_login_client,
      api_client: Edukator.Accounts.ExternalLogin.ApiClient,
      base_url: "http://localhost:#{bypass.port}/"
    )

    {:ok, bypass: bypass}
  end

  describe "LocalToExternal - authenticate" do
    test "when trial is expired", %{bypass: bypass} do
      date =
        "America/Sao_Paulo"
        |> Timex.now()
        |> Timex.to_date()
        |> Timex.shift(days: -3)
        |> Timex.format!("{YYYY}-{0M}-{D}")

      email = "new_user@teste.com"

      response_body = """
          {
            "email": "#{email}",
            "name": "garagem PRem",
            "account_type": "TRIAL",
            "trial_expire_date": "#{date}"
          }
      """

      Bypass.expect_once(bypass, "POST", "/", fn conn ->
        Plug.Conn.resp(conn, 200, response_body)
      end)

      args = %{email: email, password: "password"}

      res = Edukator.Accounts.Authentication.LocalToExternal.authenticate(args)

      assert res ==
               {:error,
                %{key: "email", messages: "Seu período de avaliação terminou, assine agora!"}}
    end

    test "when trial is not expired", %{bypass: bypass} do
      date =
        "America/Sao_Paulo"
        |> Timex.now()
        |> Timex.to_date()
        |> Timex.shift(days: 3)

      email = "new_user@teste.com"

      response_body = """
          {
            "email": "#{email}",
            "name": "garagem PRem",
            "account_type": "TRIAL",
            "trial_expire_date": "#{date}"
          }
      """

      Bypass.expect_once(bypass, "POST", "/", fn conn ->
        Plug.Conn.resp(conn, 200, response_body)
      end)

      args = %{email: email, password: "password"}

      res = Edukator.Accounts.Authentication.LocalToExternal.authenticate(args)
      assert {:ok, %Edukator.Accounts.User{}} = res
    end
  end
end
