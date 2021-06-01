defmodule Edukator.Questions.Teacher do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset

  schema "teachers" do
    field :name, :string
    field :email, :string
    has_many(:comments, Edukator.Questions.Comment)

    timestamps()
  end

  def changeset(teacher, attrs) do
    teacher
    |> cast(attrs, [:name, :email])
    |> validate_required([:name])
  end
end
