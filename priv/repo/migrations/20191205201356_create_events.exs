defmodule Edukator.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:category, :string)
      add(:action, :string)
      add(:label, :string)
      add(:value, :integer)
      add(:properties, :map)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end
  end
end
