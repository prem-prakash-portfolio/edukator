defmodule Edukator.Questions.QuestionTag do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset
  alias Edukator.Questions.Tag
  alias Edukator.Questions.Question

  schema "questions_tags" do
    belongs_to(:tag, Tag)
    belongs_to(:question, Question)

    timestamps()
  end

  @doc false
  def changeset(tag_question, attrs) do
    tag_question
    |> cast(attrs, [:question_id])
    |> validate_required([:question_id])
  end

  @doc false
  def create_changeset(tag_question, attrs) do
    tag_question
    |> cast(attrs, [:tag_id, :question_id])
    |> validate_required([:tag_id, :question_id])
  end
end
