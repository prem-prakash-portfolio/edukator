defmodule Edukator.Questions.QuestionAlternative do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset
  alias Edukator.Questions.Question

  schema "question_alternatives" do
    field :content, :string
    field :correct, :boolean, default: false
    field :counter, :integer
    field :letter, :string
    belongs_to(:question, Question)

    timestamps()
  end

  @doc false
  def changeset(question_alternative, attrs) do
    question_alternative
    |> cast(attrs, [:content, :correct, :counter, :letter])
    |> validate_required([:content, :correct, :counter, :letter])
  end
end
