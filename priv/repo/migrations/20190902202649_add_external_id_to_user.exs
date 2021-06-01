defmodule Edukator.Repo.Migrations.AddExternalIdToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:external_id, :integer)
    end
  end
end
