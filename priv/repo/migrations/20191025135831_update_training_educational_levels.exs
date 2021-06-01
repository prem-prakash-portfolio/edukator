defmodule Edukator.Repo.Migrations.UpdateTrainingEducationalLevels do
  use Ecto.Migration

  def change do
    execute("""
    UPDATE trainings
      SET filter = filter || '{"educational_levels":[]}'
        WHERE filter->>'educational_levels' is null;
    """)
  end
end
