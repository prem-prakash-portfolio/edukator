defmodule Edukator.Repo.Migrations.AddCommentFieldToQuestion do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add(:comment, :string)
    end
  end
end
