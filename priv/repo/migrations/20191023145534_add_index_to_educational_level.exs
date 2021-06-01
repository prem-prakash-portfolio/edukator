defmodule Edukator.Repo.Migrations.AddIndexToEducationalLevel do
  use Ecto.Migration

  def change do
    create(index("exams", [:educational_level]))
  end
end
