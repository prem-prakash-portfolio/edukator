defmodule Edukator.Repo.Migrations.AddNotificationSettingsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:notification_settings, :map)
    end
  end
end
