defmodule Edukator.Repo.Migrations.AddToursToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:viewed_tours, :map)
    end
  end
end
