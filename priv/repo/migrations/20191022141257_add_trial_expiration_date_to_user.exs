defmodule Edukator.Repo.Migrations.AddTrialExpirationDateToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:trial_expiration_date, :utc_datetime)
    end
  end
end
