defmodule Edukator.Repo.Migrations.RemoveExternalIdFromUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove(:external_id, :integer)
    end
  end
end
