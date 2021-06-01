defmodule EdukatorWeb.Resolvers.ExamSessionResolver do
  @moduledoc false
  alias Edukator.Exams
  alias Edukator.ExamSessions

  def list(_parent, args, %{
        context: %{current_user: current_user, tenant: tenant}
      }) do
    {:ok, Exams.list_exams(args, current_user, tenant)}
  end

  def list(_parent, _args, _context), do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def show(_parent, args, %{
        context: %{current_user: current_user, tenant: tenant}
      }) do
    case ExamSessions.get_exam_session(args[:id], current_user.id, tenant) do
      nil -> {:error, "Not found"}
      exam -> {:ok, exam}
    end
  end

  def show(_parent, _args, _context), do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def create_exam_session(_parent, args, %{
        context: %{current_user: current_user, tenant: tenant}
      }) do
    ExamSessions.create_exam_session(args[:exam_id], current_user, tenant)
  end

  def create_exam_session(_parent, _args, _context),
    do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def delete_exam_session(_parent, args, %{context: %{current_user: current_user, tenant: tenant}}) do
    ExamSessions.delete_exam_session(args, current_user, tenant)
  end

  def delete_exam_session(_parent, _args, _context),
    do: {:error, %{key: "auth", messages: "Unauthenticated"}}
end
