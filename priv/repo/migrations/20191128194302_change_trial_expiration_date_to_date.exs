defmodule Edukator.Repo.Migrations.ChangeTrialExpirationDateToDate do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify(:trial_expiration_date, :date)
    end
  end
end
