defmodule Edukator.Repo.Migrations.CreateUserGoals do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:goals, :jsonb)
    end
  end
end
