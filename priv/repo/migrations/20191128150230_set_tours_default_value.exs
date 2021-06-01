defmodule Edukator.Repo.Migrations.SetToursDefaultValue do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify(:viewed_tours, :map, default: %{menu: false, search: false, new_training: false})
    end

    execute("""
    UPDATE users
      SET viewed_tours = '{"menu": false, "search": false, "new_training": false}'
        WHERE viewed_tours is null;
    """)
  end
end
