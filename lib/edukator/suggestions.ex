defmodule Edukator.Suggestions do
  @moduledoc false
  alias Edukator.Repo
  import Ecto.Query
  alias Edukator.Exams.Exam

  def get_suggestions(%{goals: %{organizations: organizations, jobs: jobs}} = user, tenant)
      when (is_list(organizations) and length(organizations) > 0) or
             (is_list(jobs) and
                length(jobs) > 0) do
    user
    |> get_same_organizations_and_jobs(tenant)
    |> get_same_jobs(user, tenant)
    |> get_same_organizations(user, tenant)
    |> get_results_or_raise(user, tenant)
  end

  def get_suggestions(_user, _tenant), do: []

  defp get_same_organizations_and_jobs(
         %{goals: %{organizations: organizations, jobs: jobs}} = user,
         tenant
       )
       when is_list(organizations) and length(organizations) > 0 and is_list(jobs) and
              length(jobs) > 0 do
    query =
      from e in Exam,
        where: e.organization_id in ^user.goals.organizations and e.job_id in ^user.goals.jobs,
        order_by: [desc: e.year],
        select: e,
        limit: 5

    results = Repo.all(query, prefix: tenant)

    case results do
      [] -> {:continue, nil}
      _ -> {:halt, results}
    end
  end

  defp get_same_organizations_and_jobs(_user, _tenant), do: {:continue, nil}

  defp get_same_jobs({:halt, results}, _user, _tenant), do: {:halt, results}

  defp get_same_jobs({:continue, _}, %{goals: %{jobs: jobs}} = user, tenant)
       when is_list(jobs) and length(jobs) > 0 do
    query =
      from e in Exam,
        where: e.job_id in ^user.goals.jobs,
        order_by: [desc: e.year],
        select: e,
        limit: 5

    results = Repo.all(query, prefix: tenant)

    case results do
      [] -> {:continue, nil}
      _ -> {:halt, results}
    end
  end

  defp get_same_jobs({:continue, _}, _user, _tenant), do: {:continue, nil}

  defp get_same_organizations({:halt, results}, _user, _tenant), do: {:halt, results}

  defp get_same_organizations(
         {:continue, _},
         %{goals: %{organizations: organizations}} = user,
         tenant
       )
       when is_list(organizations) and length(organizations) > 0 do
    query =
      from e in Exam,
        where: e.organization_id in ^user.goals.organizations,
        order_by: [desc: e.year],
        select: e,
        limit: 5

    results = Repo.all(query, prefix: tenant)

    case results do
      [] -> {:continue, nil}
      _ -> {:halt, results}
    end
  end

  defp get_same_organizations({:continue, _}, _user, _tenant), do: {:continue, nil}

  defp get_results_or_raise({:halt, results}, _user, _tenant), do: results

  defp get_results_or_raise(
         {:continue, _},
         %{id: id, goals: %{organizations: organizations, jobs: jobs}} = _user,
         tenant
       ) do
    error_msg =
      "No organizations with ids #{Enum.join(organizations, ", ")} or jobs with ids #{
        Enum.join(jobs, ", ")
      } found for user id #{id} on tenant #{tenant}"

    raise RuntimeError, error_msg
  end
end
