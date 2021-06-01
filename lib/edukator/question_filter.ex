defmodule Edukator.QuestionFilter do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Edukator.Repo
  alias Edukator.Exams.{Author, Exam, Organization}
  alias Edukator.QuestionFilterQuery
  alias Edukator.Questions.Tag

  def filter(%{filters: filters}, %{id: user_id} = _user, tenant \\ "public") do
    filters = process_filters(filters)
    organizations = get_all_organizations(tenant)
    years = get_years_from_organizations(filters.organizations, user_id, tenant)
    authors = get_authors_from_organizations(filters.organizations, user_id, tenant)

    educational_levels =
      get_educational_levels_from_organizations(filters.organizations, user_id, tenant)

    tags = get_tags_from_scope(filters, user_id, tenant)

    disciplines = Enum.filter(tags, &(&1.kind == "Discipline"))
    subjects = Enum.filter(tags, &(&1.kind == "Subject"))
    total_questions = get_total_questions(filters, user_id, tenant)

    %{
      total_questions: total_questions,
      organizations: organizations,
      years: years,
      authors: authors,
      disciplines: disciplines,
      subjects: subjects,
      educational_levels: educational_levels
    }
  end

  def process_filters(filters) when is_map(filters) do
    arrays =
      [
        :organizations,
        :years,
        :authors,
        :disciplines,
        :subjects,
        :educational_levels
      ]
      |> Enum.map(fn key ->
        values = filters |> Map.get(key, []) |> Enum.reject(&is_nil/1)
        {key, values}
      end)
      |> Enum.into(%{})

    filters
    |> Map.merge(arrays)
  end

  def process_filters(filters) when is_nil(filters), do: %{}

  defp get_all_organizations(tenant) do
    query = from(Organization, order_by: [asc: :name])
    Repo.all(query, prefix: tenant)
  end

  defp get_years_from_organizations([], _user_id, tenant) do
    query =
      from(e in Exam,
        distinct: true,
        order_by: [desc: e.year],
        select: %{id: e.year, name: e.year}
      )

    Repo.all(query, prefix: tenant)
  end

  defp get_years_from_organizations(organizations, user_id, tenant) do
    query =
      from [exam: e] in QuestionFilterQuery.build_query(
             %{organizations: organizations},
             user_id
           ),
           distinct: true,
           order_by: [desc: e.year],
           select: %{id: e.year, name: e.year}

    Repo.all(query, prefix: tenant)
  end

  defp get_educational_levels_from_organizations([], _user_id, tenant) do
    query =
      from(e in Exam,
        distinct: true,
        where: not is_nil(e.educational_level),
        order_by: [desc: e.educational_level],
        select: %{id: e.educational_level, name: e.educational_level}
      )

    Repo.all(query, prefix: tenant)
  end

  defp get_educational_levels_from_organizations(organizations, user_id, tenant) do
    query =
      from [exam: e] in QuestionFilterQuery.build_query(
             %{organizations: organizations},
             user_id
           ),
           where: not is_nil(e.educational_level),
           distinct: true,
           order_by: [desc: e.educational_level],
           select: %{id: e.educational_level, name: e.educational_level}

    Repo.all(query, prefix: tenant)
  end

  defp get_authors_from_organizations([], _user_id, tenant) do
    query = from(Author, order_by: [asc: :name])
    Repo.all(query, prefix: tenant)
  end

  defp get_authors_from_organizations(organizations, user_id, tenant) do
    query =
      from [exam: e] in QuestionFilterQuery.build_query(
             %{organizations: organizations},
             user_id
           ),
           join: a in assoc(e, :author),
           distinct: true,
           order_by: [asc: a.name],
           select: a

    Repo.all(query, prefix: tenant)
  end

  defp get_tags_from_scope(filters, user_id, tenant) do
    filters = build_scoped_questions_dependent(filters)

    query =
      case filters do
        %{organizations: [], years: [], authors: [], disciplines: [], subjects: []} ->
          from(t in Tag, order_by: [asc: :name])

        _ ->
          from q in QuestionFilterQuery.build_query(filters, user_id),
            join: t in assoc(q, :tags),
            distinct: true,
            order_by: [asc: t.name],
            select: t
      end

    Repo.all(query, prefix: tenant)
  end

  defp get_total_questions(filters, user_id, tenant) do
    filters
    |> QuestionFilterQuery.build_query(user_id)
    |> Repo.aggregate(:count, :id, prefix: tenant)
  end

  defp build_scoped_questions_dependent(%{
         organizations: organizations,
         years: years,
         authors: authors,
         disciplines: disciplines,
         subjects: subjects
       }) do
    if length(organizations) > 0 do
      %{
        organizations: organizations,
        years: years,
        authors: authors,
        disciplines: [],
        subjects: []
      }
    else
      %{
        organizations: organizations,
        years: years,
        authors: authors,
        disciplines: disciplines,
        subjects: subjects
      }
    end
  end
end
