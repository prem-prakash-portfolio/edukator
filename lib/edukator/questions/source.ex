defmodule Edukator.Questions.QuestionSource do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset
  alias Edukator.Questions.Question

  schema "question_sources" do
    field :source_id, :string
    field :source_name, :string
    belongs_to(:question, Question)

    timestamps()
  end

  @doc false
  def changeset(source, attrs) do
    source
    |> cast(attrs, [:source_id, :source_name])
    |> validate_required([:source_id, :source_name])
  end
end
