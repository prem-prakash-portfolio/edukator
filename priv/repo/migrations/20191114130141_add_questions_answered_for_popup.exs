defmodule Edukator.Repo.Migrations.AddQuestionsAnsweredForPopup do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:answered_questions_for_popup, :integer, default: 0)
    end
  end
end
