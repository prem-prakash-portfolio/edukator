defmodule Edukator.Exams do
  @moduledoc """
  The Exams context.
  """

  import Ecto.Query, warn: false
  alias Edukator.Repo

  alias Edukator.Exams.{Exam, Job, Organization}
  alias Edukator.ExamSessions.ExamSession

  def list_organizations(ids, tenant \\ "public") do
    query =
      from o in Organization,
        distinct: true,
        join: e in Exam,
        on: e.organization_id == o.id,
        where: o.id in ^ids,
        order_by: [asc: o.name],
        select: o

    Repo.all(query, prefix: tenant)
  end

  def list_jobs(ids, tenant \\ "public") do
    query =
      from j in Job,
        distinct: true,
        join: e in Exam,
        on: e.job_id == j.id,
        where: j.id in ^ids,
        order_by: [asc: j.name],
        select: j

    Repo.all(query, prefix: tenant)
  end

  def list_organizations_and_jobs(tenant) do
    organizations_query =
      from o in Organization,
        distinct: true,
        join: e in Exam,
        on: e.organization_id == o.id,
        select: %{id: o.id, name: o.name},
        order_by: [asc: o.name]

    jobs_query =
      from j in Job,
        distinct: true,
        join: e in Exam,
        on: e.job_id == j.id,
        select: %{id: j.id, name: j.name},
        order_by: [asc: j.name]

    %{
      organizations: Repo.all(organizations_query, prefix: tenant),
      jobs: Repo.all(jobs_query, prefix: tenant)
    }
  end

  def list_exams(
        %{type: type, search_text: search_text, size: size} = args,
        user,
        tenant
      ) do
    %{entries: entries, metadata: metadata} =
      list_exams_base_query()
      |> filter_search_text(search_text)
      |> filter_type(type)
      |> Repo.paginate(
        [
          after: args[:cursor_after],
          cursor_fields: [:id],
          limit: size,
          include_total_count: true,
          total_count_limit: :infinity
        ],
        prefix: tenant
      )

    has_more = if length(entries) >= size, do: true, else: false

    query = from es in ExamSession, where: es.user_id == ^user.id, order_by: [desc: es.updated_at]
    entries = Repo.preload(entries, exam_sessions: query)

    %{
      exams: entries,
      has_more: has_more,
      cursor_after: metadata.after,
      total_count: metadata.total_count
    }
  end

  defp list_exams_base_query do
    from e in Exam,
      left_join: a in assoc(e, :author),
      left_join: j in assoc(e, :job),
      left_join: o in assoc(e, :organization),
      preload: [author: a, job: j, organization: o],
      order_by: [desc: e.year],
      order_by: [e.name]
  end

  defp filter_type(query, :MOCK), do: from(q in query, where: ilike(q.name, "Simulado%"))
  defp filter_type(query, :OLD_EXAM), do: from(q in query, where: not ilike(q.name, "Simulado%"))
  defp filter_type(query, _), do: query

  defp filter_search_text(query, ""), do: query
  defp filter_search_text(query, nil), do: query

  defp filter_search_text(query, search_text) do
    query_list = String.split(search_text, " ")

    Enum.reduce(query_list, query, fn word, acc ->
      ilike = "%#{word}%"
      from(q in acc, where: fragment("unaccent(?) ILIKE unaccent(?)", q.name, ^ilike))
    end)
  end

  def get_sessions_data(id, tenant \\ "public") do
    exam = Repo.get!(Exam, id, prefix: tenant)
    exam.sessions_data
  end

  def update_sessions_data(exam_session, tenant \\ "public") do
    mean =
      (exam_session.correct_questions_count +
         exam_session.exam.sessions_data.finished_sessions_count *
           exam_session.exam.sessions_data.mean_percentage_correct) /
        (exam_session.exam.sessions_data.finished_sessions_count + 1)

    attrs = %{
      sessions_data: %{
        mean_percentage_correct: mean,
        finished_sessions_count: exam_session.exam.sessions_data.finished_sessions_count + 1
      }
    }

    exam_session.exam
    |> Repo.preload([:author, :organization])
    |> Exam.changeset(attrs)
    |> Repo.update(prefix: tenant)
  end
end
