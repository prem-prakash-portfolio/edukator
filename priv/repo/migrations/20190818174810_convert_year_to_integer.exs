defmodule Edukator.Repo.Migrations.ConvertYearToInteger do
  use Ecto.Migration

  def up do
    execute("""
       ALTER TABLE exams
         ALTER COLUMN year
           TYPE integer
           USING year::integer;
    """)
  end
end
