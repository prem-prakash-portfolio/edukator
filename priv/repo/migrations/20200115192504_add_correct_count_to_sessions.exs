defmodule Edukator.Repo.Migrations.AddCorrectCountToSessions do
  use Ecto.Migration

  def change do
    alter table(:exam_sessions) do
      add(:correct_questions_count, :integer, default: 0)
    end
  end
end
