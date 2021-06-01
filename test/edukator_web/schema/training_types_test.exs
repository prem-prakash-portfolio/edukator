defmodule EdukatorWeb.Schema.TrainingTypesTest do
  use EdukatorWeb.ConnCase, async: true
  use EdukatorWeb.AuthHelper
  import Edukator.Factory
  alias Edukator.Repo
  alias Edukator.Trainings.Training

  describe "delete" do
    setup %{conn: conn} do
      user = insert(:user)
      trainings = insert_list(2, :training, user: user)
      conn = conn |> authenticate(user)
      %{conn: conn, training: List.first(trainings)}
    end

    test "should delete training", %{conn: conn, training: training} do
      query = """
      mutation DeleteTraining {
        delete_training(id: #{training.id}) {
          id
        }
      }
      """

      res =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      assert res["data"]["delete_training"]["id"] == "#{training.id}"
      assert Repo.aggregate(Training, :count, :id) == 1
    end
  end
end
