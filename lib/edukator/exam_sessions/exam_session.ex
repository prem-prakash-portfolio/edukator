defmodule Edukator.ExamSessions.ExamSession do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset

  alias Edukator.Accounts.User
  alias Edukator.Exams.Exam
  alias Edukator.Questions.Question
  alias Edukator.Responses.Response

  schema "exam_sessions" do
    field :responses_count, :integer, default: 0
    field :correct_questions_count, :integer, default: 0
    belongs_to(:exam, Exam)
    belongs_to(:user, User)
    has_many(:responses, Response, on_delete: :delete_all)

    many_to_many(:questions, Question,
      join_through: "exam_questions",
      join_keys: [exam_id: :id, question_id: :id]
    )

    timestamps()
  end

  @doc false
  def changeset(exam_session, attrs) do
    exam_session
    |> cast(attrs, [:responses_count, :correct_questions_count])
    |> cast_assoc(:exam, required: true)
    |> cast_assoc(:user, required: true)
    |> validate_required([:responses_count])
  end

  @doc false
  def create_changeset(exam_session, attrs) do
    exam_session
    |> cast(attrs, [:exam_id, :user_id])
    |> validate_required([:exam_id, :user_id])
  end
end
