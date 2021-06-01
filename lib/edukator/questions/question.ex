defmodule Edukator.Questions.Question do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset
  alias Edukator.Exams.Exam
  alias Edukator.Questions.{QuestionAlternative, Tag, Comment}

  schema "questions" do
    field :broken, :boolean, default: false
    field :cancelled, :boolean, default: false
    field :content, :string
    field :outdated, :boolean, default: false
    field :difficulty, :float
    field :position, :integer, virtual: true
    field :response, :map, virtual: true
    has_many(:question_alternatives, QuestionAlternative)
    has_one(:comment, Comment)

    many_to_many(:tags, Tag,
      join_through: "questions_tags",
      join_keys: [question_id: :id, tag_id: :id]
    )

    many_to_many(:subjects, Tag,
      join_through: "questions_tags",
      join_keys: [question_id: :id, tag_id: :id],
      where: [kind: "Subject"]
    )

    many_to_many(:disciplines, Tag,
      join_through: "questions_tags",
      join_keys: [question_id: :id, tag_id: :id],
      where: [kind: "Discipline"]
    )

    many_to_many(:videos, Tag,
      join_through: "questions_tags",
      join_keys: [question_id: :id, tag_id: :id],
      where: [kind: "Video"]
    )

    many_to_many(:exams, Exam, join_through: "exam_questions")

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:broken, :cancelled, :content, :outdated, :difficulty])
    |> validate_required([:broken, :cancelled, :content, :outdated, :difficulty])
  end
end
