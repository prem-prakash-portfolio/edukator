defmodule Edukator.Repo.Migrations.SetGoalsDefaultValue do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify(:goals, :map, default: %{organizations: [], jobs: []})
    end

    execute("""
    UPDATE users
      SET goals = '{"organizations": [], "jobs": []}'
        WHERE goals is null;
    """)
  end
end
