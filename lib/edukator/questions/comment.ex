defmodule Edukator.Questions.Comment do
  @moduledoc false

  use Edukator.Schema
  import Ecto.Changeset
  alias Edukator.Questions.Question
  alias Edukator.Questions.Teacher

  schema "comments" do
    field :content, :string
    belongs_to(:question, Question)
    belongs_to(:teacher, Teacher)

    timestamps()
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
