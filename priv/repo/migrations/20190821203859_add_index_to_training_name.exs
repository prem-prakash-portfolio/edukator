defmodule Edukator.Repo.Migrations.AddIndexToTrainingName do
  use Ecto.Migration

  def change do
    create(index("trainings", [:name]))
  end
end
