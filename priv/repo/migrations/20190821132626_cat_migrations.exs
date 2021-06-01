defmodule Edukator.Repo.Migrations.CATMigrations do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add(:difficulty, :float)
    end

    execute("UPDATE questions SET difficulty = 1 - probability WHERE probability IS NOT NULL;")

    alter table(:questions) do
      remove(:probability)
    end

    alter table(:training_questions) do
      add(:position, :integer)
    end

    alter table(:trainings) do
      add(:algorithm, :string)
      add(:filter, :map)
    end
  end
end
