defmodule Edukator.ExamSessionsTest do
  use Edukator.DataCase
  import Edukator.Factory

  alias Edukator.ExamSessions

  describe "correct_questions_count" do
    test "should update correct questions count properly" do
      user = insert(:user)
      exam = insert(:exam)
      exam_session = insert(:exam_session, user: user, exam: exam, correct_questions_count: 3)

      {:ok, updated} = ExamSessions.update_correct_questions_count(exam_session)

      assert updated.correct_questions_count == 4
    end
  end
  #
  # describe "exam_sessions" do
  #   alias Edukator.ExamSessions.ExamSession
  #
  #   @valid_attrs %{responses_count: 42}
  #   @update_attrs %{responses_count: 43}
  #   @invalid_attrs %{responses_count: nil}
  #
  #   def exam_session_fixture(attrs \\ %{}) do
  #     {:ok, exam_session} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> ExamSessions.create_exam_session()
  #
  #     exam_session
  #   end
  #
  #   test "list_exam_sessions/0 returns all exam_sessions" do
  #     exam_session = exam_session_fixture()
  #     assert ExamSessions.list_exam_sessions() == [exam_session]
  #   end
  #
  #   test "get_exam_session!/1 returns the exam_session with given id" do
  #     exam_session = exam_session_fixture()
  #     assert ExamSessions.get_exam_session!(exam_session.id) == exam_session
  #   end
  #
  #   test "create_exam_session/1 with valid data creates a exam_session" do
  #     assert {:ok, %ExamSession{} = exam_session} = ExamSessions.create_exam_session(@valid_attrs)
  #     assert exam_session.responses_count == 42
  #   end
  #
  #   test "create_exam_session/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = ExamSessions.create_exam_session(@invalid_attrs)
  #   end
  #
  #   test "update_exam_session/2 with valid data updates the exam_session" do
  #     exam_session = exam_session_fixture()
  #     assert {:ok, %ExamSession{} = exam_session} = ExamSessions.update_exam_session(exam_session, @update_attrs)
  #     assert exam_session.responses_count == 43
  #   end
  #
  #   test "update_exam_session/2 with invalid data returns error changeset" do
  #     exam_session = exam_session_fixture()
  #     assert {:error, %Ecto.Changeset{}} = ExamSessions.update_exam_session(exam_session, @invalid_attrs)
  #     assert exam_session == ExamSessions.get_exam_session!(exam_session.id)
  #   end
  #
  #   test "delete_exam_session/1 deletes the exam_session" do
  #     exam_session = exam_session_fixture()
  #     assert {:ok, %ExamSession{}} = ExamSessions.delete_exam_session(exam_session)
  #     assert_raise Ecto.NoResultsError, fn -> ExamSessions.get_exam_session!(exam_session.id) end
  #   end
  #
  #   test "change_exam_session/1 returns a exam_session changeset" do
  #     exam_session = exam_session_fixture()
  #     assert %Ecto.Changeset{} = ExamSessions.change_exam_session(exam_session)
  #   end
  # end
end
