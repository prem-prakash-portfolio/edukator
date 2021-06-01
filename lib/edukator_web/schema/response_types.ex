defmodule EdukatorWeb.Schema.ResponseTypes do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias EdukatorWeb.Data
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "A response"
  object :response do
    field(:id, :id)
    field :exam_session_id, :id
    field :training_id, :id
    field :question_id, :id
    field :question_alternative_id, :id
    field :correct, :boolean

    field :question_alternative, :question_alternative,
      resolve: dataloader(Data, :question_alternative)
  end

  object :response_mutations do
    # @desc "Responds a question with an alternative"
    # field :answer_question, :response do
    #   arg(:exam_session_id, :id)
    #   arg(:training_id, :id)
    #   arg(:question_id, non_null(:id))
    #   arg(:question_alternative_id, :id)
    #
    #   resolve(&Resolvers.ResponseResolver.answer_question/3)
    #
    #   middleware(HandleErrors)
    # end
  end
end
