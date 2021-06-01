defmodule Edukator.Repo.Migrations.AddAuthTokenToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:auth_token, :string)
    end
  end
end
