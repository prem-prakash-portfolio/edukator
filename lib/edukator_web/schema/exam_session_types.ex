defmodule EdukatorWeb.Schema.ExamSessionTypes do
  @moduledoc false
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  alias DeliriumTremex.Middleware.HandleErrors
  alias EdukatorWeb.{Data, Resolvers}

  @desc "Exam session"
  object :exam_session do
    field(:id, :id)
    field :responses_count, :integer
    field :exam, :exam, resolve: dataloader(Data, :exam)
    field :questions, list_of(:question)
    field :responses, list_of(:response), resolve: dataloader(Data, :responses)
  end

  @desc "Exam page"
  object :exams_page do
    field :exams, list_of(:exam)
    field :has_more, :boolean
    field :cursor_after, :string
    field :total_count, :integer
  end

  @desc "Exam types"
  enum :exam_type do
    value(:OLD_EXAM)
    value(:MOCK)
  end

  object :exam_session_queries do
    @desc "Get all exams and exam sessions"
    field :exams_page, :exams_page do
      arg(:cursor_after, :string)
      arg(:size, :integer)
      arg(:type, :exam_type)
      arg(:search_text, :string)
      resolve(&Resolvers.ExamSessionResolver.list/3)
      middleware(HandleErrors)
    end

    @desc "Get exam"
    field :exam_session, :exam_session do
      arg(:id, non_null(:id))
      resolve(&Resolvers.ExamSessionResolver.show/3)
      middleware(HandleErrors)
    end
  end

  object :exam_session_mutations do
    @desc "Start Exam Session for an Exam"
    field :create_exam_session, :exam do
      arg(:exam_id, non_null(:id))
      resolve(&Resolvers.ExamSessionResolver.create_exam_session/3)
      middleware(HandleErrors)
    end

    @desc "Remove an Exam Session"
    field :delete_exam_session, :exam_session do
      arg(:id, non_null(:id))

      resolve(&Resolvers.ExamSessionResolver.delete_exam_session/3)
      middleware(HandleErrors)
    end
  end
end
