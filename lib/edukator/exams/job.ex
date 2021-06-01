defmodule Edukator.Exams.Job do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :name, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
  end
end
