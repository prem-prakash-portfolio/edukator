defmodule Edukator.Repo.Migrations.SwitchCommentField do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      modify(:comment, :text)
    end
  end
end
