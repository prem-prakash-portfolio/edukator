defmodule Edukator.Repo.Migrations.AddFieldsToCourses do
  use Ecto.Migration

  def change do
    alter table(:courses) do
      add(:compulsory_attendance, :boolean, default: true)
    end
  end
end
