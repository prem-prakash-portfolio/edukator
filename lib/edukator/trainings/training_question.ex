defmodule Edukator.Trainings.TrainingQuestion do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset
  alias Edukator.Trainings.Training
  alias Edukator.Questions.Question

  schema "training_questions" do
    belongs_to(:training, Training)
    belongs_to(:question, Question)
    field(:position, :integer)

    timestamps()
  end

  @doc false
  def changeset(training_question, attrs) do
    training_question
    |> cast(attrs, [:question_id, :position])
    |> validate_required([:question_id, :position])
  end

  @doc false
  def create_changeset(training_question, attrs) do
    training_question
    |> cast(attrs, [:training_id, :question_id, :position])
    |> validate_required([:training_id, :question_id, :position])
  end
end
