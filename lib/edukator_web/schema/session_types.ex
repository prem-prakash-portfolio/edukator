defmodule EdukatorWeb.Schema.SessionTypes do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias EdukatorWeb.Resolvers
  alias DeliriumTremex.Middleware.HandleErrors

  object :session do
    field :exam_session, :exam_session
    field :training, :training

    field(:questions, list_of(:question)) do
      resolve(&Resolvers.QuestionResolver.list/3)
    end
  end

  object :answer_question do
    field :exam_session, :exam_session
    field :training, :training
    field(:question, :question)
    field(:show_trial_invitation, :boolean)
  end

  @desc "User Sessions page"
  object :user_sessions do
    field(:trainings, list_of(:training))
    field(:exams, list_of(:exam))
  end

  object :session_queries do
    @desc "Get session"
    field :session, :session do
      arg(:id, non_null(:id))
      arg(:type, :string)

      resolve(&Resolvers.SessionResolver.show/3)
      middleware(HandleErrors)
    end

    @desc "User sessions"
    field :user_sessions, :user_sessions do
      arg(:search_text, :string)
      arg(:size, :integer)

      resolve(&Resolvers.SessionResolver.list_sessions/3)
      middleware(HandleErrors)
    end
  end

  object :session_mutations do
    @desc "Responds a question with an alternative"
    field :answer_question, :answer_question do
      arg(:id, non_null(:id))
      arg(:type, :string)
      arg(:question_id, non_null(:id))
      arg(:question_alternative_id, :id)

      resolve(&Resolvers.ResponseResolver.answer_question/3)
      middleware(HandleErrors)
    end
  end
end
