defmodule Edukator.QuestionFilterQuery do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Edukator.Questions.Question
  alias Edukator.Repo
  alias Edukator.Responses.Response

  def build_query(filters, user_id) do
    query = from(q in Question, as: :question)

    query
    |> filter_cancelled_questions
    |> filter_outdated_questions
    |> filter_answered_questions(filters, user_id)
    |> filter_organization(filters)
    |> filter_year(filters)
    |> filter_author(filters)
    |> filter_discipline(filters)
    |> filter_subject(filters)
    |> filter_educational_level(filters)
  end

  defp filter_cancelled_questions(query) do
    from q in query, where: q.cancelled == false
  end

  defp filter_outdated_questions(query) do
    from q in query, where: q.outdated == false
  end

  defp filter_answered_questions(
         query,
         %{answered_questions: "answered", correct_questions: correct_questions},
         user_id
       )
       when correct_questions in ["correct", "wrong"] do
    from q in query,
      join: r in Response,
      on: r.question_id == q.id,
      join: qa in assoc(r, :question_alternative),
      left_join: t in assoc(r, :training),
      left_join: es in assoc(r, :exam_session),
      where: es.user_id == ^user_id or t.user_id == ^user_id,
      where: qa.correct == ^(correct_questions == "correct"),
      distinct: true
  end

  defp filter_answered_questions(query, %{answered_questions: "answered"}, user_id) do
    from q in query,
      join: r in Response,
      on: r.question_id == q.id,
      left_join: t in assoc(r, :training),
      left_join: es in assoc(r, :exam_session),
      where: es.user_id == ^user_id or t.user_id == ^user_id,
      distinct: true
  end

  defp filter_answered_questions(query, %{answered_questions: "unanswered"}, user_id) do
    q =
      from(r in Response,
        left_join: t in assoc(r, :training),
        left_join: es in assoc(r, :exam_session),
        where: es.user_id == ^user_id or t.user_id == ^user_id,
        distinct: true,
        select: r.question_id
      )

    answered_questions = Repo.all(q)

    from q in query, where: q.id not in ^answered_questions
  end

  defp filter_answered_questions(query, _filters, _user_id), do: query

  defp filter_organization(query, %{organizations: organizations})
       when is_list(organizations) and length(organizations) > 0 do
    from q in query,
      join: e in assoc(q, :exams),
      as: :exam,
      join: o in assoc(e, :organization),
      as: :organization,
      where: o.id in ^organizations
  end

  defp filter_organization(query, _), do: query

  defp filter_year(query, %{years: years}) when is_list(years) and length(years) > 0 do
    from q in query,
      join: e in assoc(q, :exams),
      where: e.year in ^years
  end

  defp filter_year(query, _), do: query

  defp filter_educational_level(query, %{educational_levels: educational_levels})
       when is_list(educational_levels) and length(educational_levels) > 0 do
    from q in query,
      join: e in assoc(q, :exams),
      where: e.educational_level in ^educational_levels
  end

  defp filter_educational_level(query, _), do: query

  defp filter_author(query, %{authors: authors}) when is_list(authors) and length(authors) > 0 do
    from q in query,
      join: e in assoc(q, :exams),
      join: o in assoc(e, :author),
      as: :author,
      where: o.id in ^authors
  end

  defp filter_author(query, _), do: query

  defp filter_discipline(query, filters) do
    disciplines = Enum.uniq(Map.get(filters, :disciplines, []))

    case disciplines do
      [_ | _] -> from q in query, join: d in assoc(q, :tags), where: d.id in ^disciplines
      _ -> query
    end
  end

  defp filter_subject(query, filters) do
    subjects = Enum.uniq(Map.get(filters, :subjects, []))

    case subjects do
      [_ | _] -> from q in query, join: s in assoc(q, :tags), where: s.id in ^subjects
      _ -> query
    end
  end

  # def filter_job_query(jobs) do
  #   from q in Question,
  #     join: e in assoc(q, :exams),
  #     join: o in assoc(e, :job),
  #     where: o.id in ^jobs,
  #     select: q.id
  # end
end
