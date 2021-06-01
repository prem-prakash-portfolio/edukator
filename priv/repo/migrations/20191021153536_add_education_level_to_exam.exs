defmodule Edukator.Repo.Migrations.AddEducationLevelToExam do
  use Ecto.Migration

  def change do
    alter table(:exams) do
      add(:educational_level, :string)
    end
  end
end
