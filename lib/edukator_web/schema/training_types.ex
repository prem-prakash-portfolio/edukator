defmodule EdukatorWeb.Schema.TrainingTypes do
  @moduledoc false
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]
  alias EdukatorWeb.{Data, Resolvers}
  alias DeliriumTremex.Middleware.HandleErrors

  @desc "Training session"
  object :training do
    field(:id, :id)
    field(:name, :string)
    field :questions_count, :integer
    field :responses_count, :integer
    field :questions, list_of(:question), resolve: dataloader(Data, :questions)
    field :responses, list_of(:response), resolve: dataloader(Data, :responses)
  end

  @desc "A filter"
  object :question_filter do
    field(:id, :id)
    field(:total_questions, :integer)
    field :organizations, list_of(:organization)
    field :years, list_of(:year)
    field :authors, list_of(:author)
    field :disciplines, list_of(:discipline)
    field :subjects, list_of(:subject)
    field :educational_levels, list_of(:educational_level)
  end

  # @desc "Training page"
  # object :trainings_page do
  #   field :trainings, list_of(:training)
  #   field :has_more, :boolean
  #   field :cursor_after, :string
  #   field :total_count, :integer
  # end

  # @desc "Training types"
  # enum :training_type do
  #   value(:OLD_EXAM)
  #   value(:MOCK)
  # end

  input_object :filters_input do
    field :organizations, list_of(:id)
    field :years, list_of(:id)
    field :authors, list_of(:id)
    field :subjects, list_of(:id)
    field :disciplines, list_of(:id)
    field :educational_levels, list_of(:id)
    field :answered_questions, :string
    field :correct_questions, :string
  end

  object :training_queries do
    @desc "Filter"
    field :question_filter, :question_filter do
      arg(:filters, :filters_input)

      resolve(&Resolvers.TrainingResolver.filter/3)
      middleware(HandleErrors)
    end

    #
    # @desc "Get all trainings"
    # field :trainings_page, :trainings_page do
    #   arg(:cursor_after, :string)
    #   arg(:size, :integer)
    #   # arg(:type, :training_type)
    #   arg(:search_text, :string)
    #   resolve(&Resolvers.TrainingResolver.list/3)
    # end

    @desc "Get training"
    field :training_session, :training do
      arg(:id, non_null(:id))

      resolve(&Resolvers.TrainingResolver.show/3)
      middleware(HandleErrors)
    end
  end

  object :training_mutations do
    @desc "Create a Training"
    field :create_training, :training do
      arg(:name, :string)
      arg(:size, :integer)
      arg(:filters, :filters_input)

      resolve(&Resolvers.TrainingResolver.create_training/3)
      middleware(HandleErrors)
    end

    @desc "Remove a training"
    field :delete_training, :training do
      arg(:id, non_null(:id))

      resolve(&Resolvers.TrainingResolver.delete_training/3)
      middleware(HandleErrors)
    end
  end
end
