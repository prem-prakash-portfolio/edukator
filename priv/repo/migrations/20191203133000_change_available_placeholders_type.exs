defmodule Edukator.Repo.Migrations.ChangeAvailablePlaceholdersType do
  use Ecto.Migration

  def change do
    alter table(:notification_types) do
      modify(:available_placeholders, :text)
    end
  end
end
