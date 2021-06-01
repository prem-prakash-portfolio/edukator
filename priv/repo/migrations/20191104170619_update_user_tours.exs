defmodule Edukator.Repo.Migrations.UpdateUserTours do
  use Ecto.Migration

  def up do
    execute("""
    UPDATE users
      SET viewed_tours = '{"menu": false, "search": false, "new_training": false}'
        WHERE viewed_tours is null;
    """)
  end

  def down do
    execute("""
    UPDATE users
      set viewed_tours = null;
    """)
  end
end
