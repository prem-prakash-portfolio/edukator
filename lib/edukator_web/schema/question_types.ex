defmodule EdukatorWeb.Schema.QuestionTypes do
  @moduledoc false
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  alias DeliriumTremex.Middleware.HandleErrors
  alias EdukatorWeb.{Data, Resolvers}

  @desc "A question"
  object :question do
    field(:id, :id)
    field :content, :string
    field :position, :integer
    field :outdated, :boolean
    field :cancelled, :boolean

    field :comment, :comment, resolve: dataloader(Data, :comment)

    field :question_alternatives, list_of(:question_alternative),
      resolve: dataloader(Data, :question_alternatives)

    field :response, :response

    field :tags, :tags do
      resolve(&Resolvers.QuestionResolver.tags/3)
    end

    field :exam_session, :exam_session
    field :exams, list_of(:exam), resolve: dataloader(Data, :exams)
  end

  @desc "An question alternative"
  object :question_alternative do
    field(:id, :id)
    field(:letter, :string)
    field(:content, :string)
    field(:correct, :boolean)
  end

  @desc "Tags"
  object :tags do
    field :subjects, list_of(:tag)
    field :disciplines, list_of(:tag)
    field :videos, list_of(:tag)
  end

  @desc "Tag"
  object :tag do
    field(:id, :id)
    field(:kind, :string)
    field(:name, :string)
    field(:slug, :string)
  end

  @desc "Video"
  object :video do
    field(:id, :id)
    field(:kind, :string)
    field(:name, :string)
    field(:slug, :string)
  end

  @desc "Subject"
  object :subject do
    field(:id, :id)
    field(:kind, :string)
    field(:name, :string)
    field(:slug, :string)
  end

  @desc "Discipline"
  object :discipline do
    field(:id, :id)
    field(:kind, :string)
    field(:name, :string)
    field(:slug, :string)
  end

  @desc "Year"
  object :year do
    field(:id, :integer)
    field(:name, :string)
  end

  @desc "Result"
  object :result do
    field(:training, :training)
    field(:exam_session, :exam_session)

    field(:sessions_data, :sessions_data) do
      resolve(&Resolvers.ExamResolver.get_sessions_data/3)
    end

    field(:questions, list_of(:question)) do
      resolve(&Resolvers.QuestionResolver.list/3)
    end
  end

  @desc "The exam sessions mean data"
  object :sessions_data do
    field :mean_percentage_correct, :integer
    field :finished_sessions_count, :integer
  end

  @desc "Educational_level"
  object :educational_level do
    field(:id, :id)
    field(:name, :string)
  end

  @desc "The question comment"
  object :comment do
    field(:id, :id)
    field(:content, :string)

    field :teacher, :teacher, resolve: dataloader(Data, :teacher)
  end

  @desc "The comment teacher"
  object :teacher do
    field(:id, :id)
    field(:name, :string)
    field(:email, :string)
  end

  object :question_queries do
    @desc "Get question"
    field :question, :question do
      arg(:id, non_null(:id))
      arg(:type, :string)
      arg(:position, non_null(:integer))

      resolve(&Resolvers.QuestionResolver.show/3)
      middleware(HandleErrors)
    end

    @desc "Result"
    field :result, :result do
      arg(:id, non_null(:id))
      arg(:type, :string)

      resolve(&Resolvers.SessionResolver.show/3)
      middleware(HandleErrors)
    end
  end
end
