defmodule EdukatorWeb.Schema.UserTypes do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias DeliriumTremex.Middleware.HandleErrors
  alias EdukatorWeb.Resolvers

  @desc "A user of the site"
  object :user do
    field(:id, :id)
    field(:email, :string)
    field(:name, :string)
    field(:account_type, :string)
    field(:phone, :string)
    field(:document, :string)
    field(:token, :string)
    field(:goals, :goals)

    field :suggested_exams, list_of(:exam) do
      resolve(&Resolvers.ExamResolver.suggested_exams/3)
      middleware(HandleErrors)
    end

    field(:viewed_tours, :viewed_tours)
    field(:updated_at, :naive_datetime)
  end

  @desc "The user's viewed tours"
  object :viewed_tours do
    field(:menu, :boolean)
    field(:search, :boolean)
    field(:new_training, :boolean)
  end

  @desc "User viewed tours input"
  input_object :viewed_tours_input do
    field(:menu, :boolean)
    field(:search, :boolean)
    field(:new_training, :boolean)
  end

  @desc "User goals"
  object :goals do
    field :organizations, list_of(:organization) do
      resolve(&Resolvers.ExamResolver.organizations/3)
      middleware(HandleErrors)
    end

    field :jobs, list_of(:job) do
      resolve(&Resolvers.ExamResolver.jobs/3)
      middleware(HandleErrors)
    end
  end

  @desc "User goals input"
  input_object :goals_input do
    field(:organizations, list_of(:id))
    field(:jobs, list_of(:id))
  end

  object :user_queries do
    @desc "Get current user"
    field :current_user, :user do
      resolve(&Resolvers.UserResolver.current_user/3)
      middleware(HandleErrors)
    end
  end

  object :user_mutations do
    # @desc "Signup"
    # field :signup, :user do
    #   arg(:name, non_null(:string))
    #   arg(:email, non_null(:string))
    #   arg(:password, non_null(:string))

    #   resolve(&Resolvers.UserResolver.signup/3)

    #   middleware(HandleErrors)

    #   middleware(fn resolution, _ ->
    #     with %{value: user} <- resolution do
    #       Map.update!(resolution, :context, fn ctx ->
    #         Map.put(ctx, :signin_user, user)
    #       end)
    #     end
    #   end)
    # end

    @desc "Authenticate"
    field :authenticate, :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.UserResolver.authenticate/3)

      middleware(HandleErrors)
    end

    @desc "Logout"
    field :logout, :string do
      resolve(&Resolvers.UserResolver.logout/3)
    end

    @desc "Update Password"
    field :update_password, type: :user do
      arg(:current_password, :string)
      arg(:password, :string)
      arg(:password_confirmation, :string)

      resolve(&Resolvers.UserResolver.update_password/3)

      middleware(HandleErrors)
    end

    @desc "Update User"
    field :update_user, type: :user do
      # arg(:email, :string)
      # arg(:name, :string)
      # arg(:phone, :string)
      # arg(:document, :string)
      # arg(:password, :string)
      # arg(:password_confirmation, :string)
      arg(:goals, :goals_input)
      arg(:viewed_tours, :viewed_tours_input)

      resolve(&Resolvers.UserResolver.update/3)

      middleware(HandleErrors)
    end
  end
end
