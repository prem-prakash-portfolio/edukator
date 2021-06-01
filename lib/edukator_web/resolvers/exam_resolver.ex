defmodule EdukatorWeb.Resolvers.ExamResolver do
  @moduledoc false
  alias Edukator.{Exams, Suggestions}

  def suggested_exams(_parent, _args, %{
        context: %{current_user: current_user, tenant: tenant}
      }) do
    {:ok, Suggestions.get_suggestions(current_user, tenant)}
  end

  def suggested_exams(_parent, _args, _context),
    do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def organizations_and_jobs(_parent, _args, %{
        context: %{current_user: _current_user, tenant: tenant}
      }) do
    {:ok, Exams.list_organizations_and_jobs(tenant)}
  end

  def organizations_and_jobs(_parent, _args, _context),
    do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def organizations(%{organizations: organizations} = _goals, _args, %{
        context: %{current_user: _current_user, tenant: tenant}
      }) do
    {:ok, Exams.list_organizations(organizations, tenant)}
  end

  def organizations(_parent, _args, _context),
    do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def jobs(%{jobs: jobs} = _goals, _args, %{
        context: %{current_user: _current_user, tenant: tenant}
      }) do
    {:ok, Exams.list_jobs(jobs, tenant)}
  end

  def jobs(_parent, _args, _context),
    do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def get_sessions_data(%{exam_session: %{exam_id: exam_id}} = _exam_session, _args, %{
      context: %{current_user: _current_user, tenant: tenant}
    }) do
      {:ok, Exams.get_sessions_data(exam_id, tenant) }
  end

  def get_sessions_data(%{training: _training}, _args, _context) do
    {:ok, nil}
  end

  def get_sessions_data(_parent, _args, _context) do
    {:error, %{key: "auth", messages: "Unauthenticated"}}
  end
end
