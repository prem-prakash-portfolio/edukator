defmodule Edukator.TrainingsTest do
  use Edukator.DataCase
  import Edukator.Factory

  alias Edukator.Trainings

  test "create_training/3" do
    tenant = "public"

    insert_list(10, :question)
    questions_quantity = 10
    name = "Meu Treino"
    filters = %{}

    args = %{size: questions_quantity, name: name, filters: filters}
    user = insert(:user)

    {:ok, training} = Trainings.create_training(args, user, tenant)

    training = training |> Repo.preload(:questions)

    assert length(training.questions) == 1
    assert training.questions_count == questions_quantity
  end
end
