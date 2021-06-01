defmodule Edukator.Questions.Tag do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset
  alias Edukator.Questions.{Question, QuestionTag}

  schema "tags" do
    field :kind, :string
    field :name, :string
    field :slug, :string

    many_to_many(:questions, Question,
      join_through: "questions_tags",
      join_keys: [question_id: :id, tag_id: :id]
    )

    has_many(:question_tags, QuestionTag)

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:kind, :name, :slug])
    |> validate_required([:kind, :name, :slug])
    |> validate_subset(:kind, ["Subject", "Discipline", "Video"])
  end
end
