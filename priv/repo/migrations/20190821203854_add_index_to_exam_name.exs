defmodule Edukator.Repo.Migrations.AddIndexToExamName do
  use Ecto.Migration

  def change do
    create(index("exams", [:name]))
  end
end
