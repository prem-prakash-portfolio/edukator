defmodule Edukator.Repo.Migrations.PopulateUserGoals do
  use Ecto.Migration

  def up do
    execute("""
    UPDATE users
      SET goals = '{"organizations": [], "jobs": []}'
        WHERE goals is null;
    """)
  end

  def down do
    execute("""
    UPDATE users
      set goals = null;
    """)
  end
end
