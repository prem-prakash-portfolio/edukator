defmodule Edukator.Repo.Migrations.AddAccountTypeToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:account_type, :string)
    end

    execute("""
    UPDATE users SET account_type = 'FULL';
    """)
  end
end
