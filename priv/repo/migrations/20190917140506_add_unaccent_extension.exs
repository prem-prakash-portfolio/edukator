defmodule Edukator.Repo.Migrations.AddUnaccentExtension do
  use Ecto.Migration

  def change do
    execute("
    CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;
    ")
  end
end
