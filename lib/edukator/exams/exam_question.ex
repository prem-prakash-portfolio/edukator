defmodule Edukator.Exams.ExamQuestion do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset
  alias Edukator.Exams.Exam
  alias Edukator.Questions.Question

  schema "exam_questions" do
    field :position, :integer
    belongs_to(:exam, Exam)
    belongs_to(:question, Question)

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:position])
    |> cast_assoc(:exam, required: true)
    |> cast_assoc(:question, required: true)
    |> validate_required([:position])
  end
end
