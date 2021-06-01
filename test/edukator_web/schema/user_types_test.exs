defmodule EdukatorWeb.Schema.UserTypesTest do
  use EdukatorWeb.ConnCase, async: true
  use EdukatorWeb.AuthHelper
  import Edukator.Factory
  import Mox

  setup :verify_on_exit!

  describe "authenticate" do
    setup do
      user = insert(:user)
      password = "s3cr3t1551m0"

      {:ok, user} =
        Edukator.Accounts.update_user(
          user,
          %{password: password, password_confirmation: password},
          "public"
        )

      [user: user, password: password]
    end

    # test "it authenticate a User", %{conn: conn, user: user, password: password} do
    #   query = """
    #   mutation authenticate {
    #     authenticate(email: "#{user.email}" password: "#{password}") {
    #       id,setup :verify_on_exit!
    #       name,
    #       email
    #     }
    #   }
    #   """

    #   res =
    #     conn
    #     |> post("/api/graphql", %{query: query})
    #     |> json_response(200)

    #   assert res == %{
    #            "data" => %{
    #              "authenticate" => %{
    #                "id" => "#{user.id}",
    #                "name" => user.name,
    #                "email" => user.email
    #              }
    #            }
    #          }
    # end

    test "it remotely authenticate an remote existing User", %{conn: conn} do
      user = insert(:user, password: "senha123")

      query = """
      mutation authenticate {
        authenticate(email: "#{user.email}" password: "#{user.password}") {
          id,
          name,
          email
        }
      }
      """

      ExternalLoginApiClientBehaviourMock
      |> expect(:login, fn _email, _password ->
        {:ok, %{name: user.name, email: user.email, account_type: "FULL"}}
      end)

      res =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      assert res["data"]["authenticate"]["email"] == user.email
    end

    test "it remotely authenticate an remote new User", %{conn: conn} do
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

      ExternalLoginApiClientBehaviourMock
      |> expect(:login, fn _email, _password ->
        {:ok, %{name: user.name, email: user.email, account_type: "FULL"}}
      end)

      res =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      assert res["data"]["authenticate"]["email"] == user.email
    end

    test "it provides an error if validations fail", %{conn: conn, user: user} do
      query = """
      mutation authenticate {
        authenticate(email: "#{user.email}" password: "wrongPassword") {
          id,
          name,
          email
        }
      }
      """

      ExternalLoginApiClientBehaviourMock
      |> expect(:login, fn _email, _password ->
        {:error, %{key: "email", messages: "Email ou senha inválidos"}}
      end)

      res =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      assert %{"errors" => [%{"message" => message}]} = res
      assert message == "Email ou senha inválidos"
    end
  end

  # describe "Signup" do
  #   test "it create a new user account", %{conn: conn} do
  #     name = "duder"
  #     email = "dude@dude.dude"
  #     password = "dudedude"

  #     query = """
  #     mutation signup {
  #       signup(name: "#{name}", email: "#{email}" password: "#{password}") {
  #         id
  #         name
  #         email
  #       }
  #     }
  #     """

  #     res =
  #       conn
  #       |> post("/api/graphql", %{query: query})
  #       |> json_response(200)

  #     assert %{
  #              "data" => %{
  #                "signup" => %{
  #                  "id" => _,
  #                  "name" => name,
  #                  "email" => email
  #                }
  #              }
  #            } = res
  #   end

  #   test "it provides an error if validations fail", %{conn: conn} do
  #     name = "duder"
  #     email = "wrongEmail"
  #     password = "dudedude"

  #     query = """
  #     mutation signup {
  #       signup(name: "#{name}", email: "#{email}" password: "#{password}") {
  #         id
  #         name
  #         email
  #       }
  #     }
  #     """

  #     res =
  #       conn
  #       |> post("/api/graphql", %{query: query})
  #       |> json_response(200)

  #     assert %{"errors" => [%{"message" => message, "key" => key}]} = res
  #     assert message == "não é válido"
  #     assert key == "email"
  #   end
  # end

  describe "currentUser" do
    setup do
      user = insert(:user, %{name: "dude"})

      [user: user]
    end

    test "gets the current User", %{conn: conn, user: user} do
      query = """
      {
        currentUser {
          name
        }
      }
      """

      res =
        conn
        |> authenticate(user)
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      assert res == %{"data" => %{"currentUser" => %{"name" => user.name}}}
    end

    test "returns nil if the User is not authenticated", %{conn: conn} do
      query = """
      {
        currentUser {
          name
        }
      }
      """

      res =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      assert res == %{"data" => %{"currentUser" => nil}}
    end
  end

  describe "logout" do
    setup %{conn: conn} do
      user = insert(:user)
      conn = conn |> authenticate(user)

      %{conn: conn, user: user}
    end

    test "Logout user", %{conn: conn} do
      query = """
      {
        currentUser {
          name
        }
      }
      """

      conn = conn |> post("/api/graphql", %{query: query})

      token = conn.private[:absinthe].context.token

      assert {:ok, user, _claims} = Edukator.Guardian.resource_from_token(token)

      query = """
      mutation Logout {
        logout
      }
      """

      conn
      |> post("/api/graphql", %{query: query})

      res = Edukator.Guardian.resource_from_token(token)
      assert res == {:error, :token_not_found}
    end
  end

  describe "update_password" do
    setup do
      password = Bcrypt.hash_pwd_salt("blablabla")

      user =
        insert(:user, %{
          encrypted_password: password
        })

      [user: user]
    end

    test "should not allow to update password when not logged", %{conn: conn} do
      current_password = "blablabla"
      password = "blobloblo"
      password_confirmation = "blobloblo"

      query = """

        mutation updatePassword {
          update_password(
            current_password: "#{current_password}"
            password: "#{password}"
            password_confirmation: "#{password_confirmation}"
          ) {
            id
            updated_at
          }
        }

      """

      res =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      assert %{"errors" => [%{"message" => message, "key" => key}]} = res
      assert message == "Unauthenticated"
      assert key == "auth"
    end

    test "should change password correctly", %{conn: conn, user: user} do
      conn = conn |> authenticate(user)

      current_password = "blablabla"
      password = "blobloblo"
      password_confirmation = "blobloblo"

      query = """

        mutation updatePassword {
          update_password(
            current_password: "#{current_password}"
            password: "#{password}"
            password_confirmation: "#{password_confirmation}"
          ) {
            id
            updated_at
          }
        }

      """

      res =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      %{"data" => %{"update_password" => %{"id" => user_id}}} = res

      updated_user = Edukator.Repo.get(Edukator.Accounts.User, user_id)

      assert updated_user.id == user.id

      assert Bcrypt.verify_pass(password, updated_user.encrypted_password)
    end
  end

  describe "MUTATIONS - update_user" do
    setup do
      [user: insert(:user)]
    end

    test "should update goals correctly", %{conn: conn, user: user} do
      conn = conn |> authenticate(user)

      organizations = insert_list(3, :organization)
      jobs = insert_list(3, :job)

      goals = """
      {
        organizations: [#{Enum.map_join(organizations, ", ", & &1.id)}]
        jobs: [#{Enum.map_join(jobs, ", ", & &1.id)}]
      }
      """

      query = """

      mutation {
        update_user(
            goals: #{goals}
          ) {
          id
          goals {
            jobs {
              id
              name
            }
            organizations {
              id
              name
            }
          }
        }
      }

      """

      res =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      %{"data" => %{"update_user" => %{"id" => user_id}}} = res

      updated_user = Edukator.Repo.get(Edukator.Accounts.User, user_id)

      assert updated_user.goals.organizations |> Enum.sort() ==
               organizations |> Enum.map(& &1.id) |> Enum.sort()

      assert updated_user.goals.jobs |> Enum.sort() ==
               jobs |> Enum.map(& &1.id) |> Enum.sort()
    end

    test "should update viewed_tours correctly", %{conn: conn} do
      user = insert(:user, viewed_tours: %{menu: false, search: false, new_training: false})
      conn = conn |> authenticate(user)

      query = """
        mutation {
          update_user(
            viewed_tours: {
              menu: true
              search: true
              new_training: false
            }
          ) {
            viewed_tours {
              menu
              search
              new_training
            }
          }
        }
      """

      res =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      %{"data" => %{"update_user" => %{"viewed_tours" => viewed_tours}}} = res

      assert viewed_tours["menu"] == true
      assert viewed_tours["search"] == true
      assert viewed_tours["new_training"] == false
    end
  end
end
