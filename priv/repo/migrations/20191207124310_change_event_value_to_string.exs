defmodule Edukator.Repo.Migrations.ChangeEventValueToString do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify(:value, :text)
      modify(:category, :text)
      modify(:action, :text)
      modify(:label, :text)
    end
  end
end
