defmodule Edukator.Repo.Migrations.AddMeanFieldToExams do
  use Ecto.Migration

  def change do
    alter table(:exams) do
      add(:sessions_data, :map, default: %{mean_percentage_correct: 0, finished_sessions_count: 0})
    end
  end
end
