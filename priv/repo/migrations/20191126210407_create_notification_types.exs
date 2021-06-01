defmodule Edukator.Repo.Migrations.CreateNotificationTypes do
  use Ecto.Migration

  def change do
    create table(:notification_types) do
      add(:name, :string)
      add(:description, :string)
      add(:identifier, :string)
      add(:title_template, :string)
      add(:body_template, :string)
      add(:available_placeholders, :map)
      add(:user_can_optin_out, :boolean, default: false, null: false)
      add(:channels, {:array, :string})

      timestamps()
    end

    create(
      unique_index(:notification_types, [:identifier],
        name: "index_notification_types_on_identifier"
      )
    )
  end
end
