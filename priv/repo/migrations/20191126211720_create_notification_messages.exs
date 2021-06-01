defmodule Edukator.Repo.Migrations.CreateNotificationMessages do
  use Ecto.Migration

  def change do
    create table(:notification_messages) do
      add(:additional_data, :map)
      add(:raw_body, :string)
      add(:raw_title, :string)
      add(:viewed_at, :utc_datetime)
      add(:deleted_at, :utc_datetime)
      add(:recipient_user_id, references(:users, on_delete: :nothing))
      add(:notification_type_id, references(:notification_types, on_delete: :nothing))

      timestamps()
    end

    create(index(:notification_messages, [:recipient_user_id]))
    create(index(:notification_messages, [:notification_type_id]))
  end
end
