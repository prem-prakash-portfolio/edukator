defmodule Edukator.Repo.Migrations.RemoveCommentFromQuestion do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      remove(:comment)
    end
  end
end
