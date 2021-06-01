defmodule EdukatorWeb.Schema.ExamSessionTypesTest do
  use EdukatorWeb.ConnCase, async: true
  use EdukatorWeb.AuthHelper
  import Edukator.Factory
  alias Edukator.Repo
  alias Edukator.ExamSessions.ExamSession

  describe "delete" do
    setup %{conn: conn} do
      user = insert(:user)
      exam_session = insert(:exam_session, user_id: user.id)
      insert(:exam_session, user_id: user.id)
      conn = conn |> authenticate(user)
      %{conn: conn, user: user, exam_session: exam_session}
    end

    test "should delete exam_session", %{conn: conn, exam_session: exam_session} do
      query = """
      mutation DeleteExamSession {
        delete_exam_session(id: #{exam_session.id}) {
          id
        }
      }
      """

      res =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(200)

      assert res["data"]["delete_exam_session"]["id"] == "#{exam_session.id}"
      assert Repo.aggregate(ExamSession, :count, :id) == 1
    end
  end
end
