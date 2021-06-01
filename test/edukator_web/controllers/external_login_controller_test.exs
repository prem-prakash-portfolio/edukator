defmodule EdukatorWeb.ExternalLoginControllerTest do
  use EdukatorWeb.ConnCase
  import Edukator.Factory
  alias Edukator.Repo
  alias Edukator.Accounts.User

  describe "login/2" do
    setup %{conn: conn} do
      %{conn: conn, token: nil}
    end

    test "invalid token", %{conn: conn} do
      conn =
        post(conn, "/login", %{
          "chave" => "aaaa",
          "nome" => "user.name",
          "email" => "user.email",
          "account_type" => "FULL"
        })

      assert response(conn, 404) =~ ""
    end

    test "insuficient parameters", %{conn: conn} do
      conn = post(conn, "/login", %{"email" => "user.email"})
      assert response(conn, 404) =~ ""
    end

    test "when user is already present", %{conn: conn, token: token} do
      user = insert(:user)
      before_count = Repo.aggregate(User, :count, :id)

      conn =
        post(conn, "/login", %{
          "chave" => token,
          "nome" => user.name,
          "email" => user.email
        })

      after_count = Repo.aggregate(User, :count, :id)
      assert after_count == before_count
      assert %{"url" => _} = json_response(conn, 200)
    end

    test "when user does not exists", %{conn: conn, token: token} do
      before_count = Repo.aggregate(User, :count, :id)
      insert(:notification_type, identifier: "welcome_message")

      conn =
        post(conn, "/login", %{
          "chave" => token,
          "nome" => "user.name",
          "email" => "user.email@example.com",
          "account_type" => "FULL"
        })

      after_count = Repo.aggregate(User, :count, :id)
      assert after_count == before_count + 1
      assert %{"url" => _} = json_response(conn, 200)
    end

    test "invalid email", %{conn: conn, token: token} do
      before_count = Repo.aggregate(User, :count, :id)

      assert_raise(Ecto.InvalidChangesetError, fn ->
        post(conn, "/login", %{
          "chave" => token,
          "nome" => "user.name",
          "email" => "invalid_email",
          "account_type" => "FULL"
        })
      end)

      after_count = Repo.aggregate(User, :count, :id)
      assert after_count == before_count
    end

    test "should send email on create user", %{conn: conn, token: token} do
      name = "paulo vivas"
      email = "paulo@garagem.com"
      insert(:notification_type, identifier: "welcome_message")

      post(conn, "/login", %{
        "chave" => token,
        "nome" => "#{name}",
        "email" => "#{email}",
        "account_type" => "FULL"
      })

      assert Swoosh.Adapters.Local.Storage.Memory.all()
             |> Enum.any?(
               &(&1.subject == "Bem vindo à plataforma de questões, #{name}" &&
                   &1.html_body == "Mensagem de boas vindas para #{name}")
             )
    end
  end

  describe "auth/2" do
    test "valid token", %{conn: conn} do
      {raw_auth_token, encrypted_auth_token} = Edukator.TokenGenerator.generate("auth_token")
      user = insert(:user, auth_token: encrypted_auth_token)

      conn = get(conn, "/auth", %{"token" => raw_auth_token})

      assert redirected_to(conn, 302) =~ "/e/"

      "/e/" <> token = redirected_to(conn)
      {:ok, claimed_user, _claims} = Edukator.Guardian.resource_from_token(token)
      assert user.id == claimed_user.id
    end
  end
end
