defmodule Edukator.Exams.Author do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset

  alias Edukator.Exams.Exam

  schema "authors" do
    field :name, :string
    field :slug, :string

    has_many(:exams, Exam)

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
  end
end
