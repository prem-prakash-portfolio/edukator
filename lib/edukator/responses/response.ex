defmodule Edukator.Responses.Response do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset

  alias Edukator.Questions.{Question, QuestionAlternative}
  alias Edukator.Trainings.Training
  alias Edukator.ExamSessions.ExamSession
  alias Edukator.Repo

  schema "responses" do
    # belongs_to(:user, User)
    belongs_to(:question, Question)
    belongs_to(:question_alternative, QuestionAlternative)
    belongs_to(:exam_session, ExamSession)
    belongs_to(:training, Training)

    timestamps()
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [])
    # |> cast_assoc(:user, required: true)
    |> cast_assoc(:question, required: true)
    |> cast_assoc(:question_alternative, required: true)
    |> cast_assoc(:exam_session)
    |> cast_assoc(:training)
    |> validate_required([])
  end

  @doc false
  def create_changeset(response, %{exam_session_id: _} = attrs) do
    response
    |> cast(attrs, [:exam_session_id, :question_id, :question_alternative_id])
    |> validate_required([:exam_session_id, :question_id])
    |> increase_association_counter(:exam_session, :responses_count)
  end

  @doc false
  def create_changeset(response, %{training_id: _} = attrs) do
    response
    |> cast(attrs, [:training_id, :question_id, :question_alternative_id])
    |> validate_required([:training_id, :question_id])
    |> increase_association_counter(:training, :responses_count)
  end

  @doc false
  def update_changeset(response, attrs) do
    response
    |> cast(attrs, [:question_alternative_id])
  end

  defp increase_association_counter(changeset, association, counter_field) do
    prepare_changes(changeset, fn changeset ->
      changeset
      |> apply_changes()
      |> Repo.preload(association)
      |> Ecto.assoc(association)
      |> Repo.update_all(inc: [{counter_field, 1}])

      changeset
    end)
  end
end
