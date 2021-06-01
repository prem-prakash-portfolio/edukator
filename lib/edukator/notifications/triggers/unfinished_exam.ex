defmodule Edukator.Notifications.Triggers.UnfinishedExam do
  @moduledoc """
  Send notifications to user related to unfinished exam
  """
  alias Edukator.Repo
  import Ecto.Query

  alias Edukator.ExamSessions.ExamSession
  alias Edukator.Accounts.User
  alias Edukator.Notifications.NotificationSender

  def run(notification_type_identifier, days, quantity \\ 3, tenant \\ "public") do
    # TODO run each user in a Elixir Task to avoid long running process,
    # to run in paralell and to retry or not in case of errors
    tenant
    |> users_with_unfinished_exams()
    |> last_responses(days, quantity, tenant)
    |> Enum.each(fn {user, exams} ->
      NotificationSender.maybe_send(user, notification_type_identifier, %{exams: exams})
    end)
  end

  defp users_with_unfinished_exams(tenant) do
    query =
      from u in User,
        join: es in assoc(u, :exam_sessions),
        join: e in assoc(es, :exam),
        where: es.responses_count < e.exam_questions_count,
        distinct: u,
        select: u

    query |> Repo.all(prefix: tenant)
  end

  defp last_responses(users, days, quantity, tenant) do
    datetime =
      "America/Sao_Paulo"
      |> Timex.now()
      |> Timex.shift(days: days)
      |> Timex.beginning_of_day()
      |> Timex.to_datetime()

    users
    |> Enum.map(fn user ->
      responses =
        from r in Edukator.Responses.Response,
          order_by: [desc: r.updated_at],
          where:
            fragment(
              "DATE_TRUNC('day', timezone('America/Sao_Paulo', ?))",
              r.updated_at
            ) == ^datetime,
          limit: 1

      query =
        from es in ExamSession,
          join: e in assoc(es, :exam),
          left_join: r in ^subquery(responses),
          on: r.exam_session_id == es.id,
          where: es.user_id == ^user.id,
          distinct: true,
          select: %{name: e.name},
          group_by: [e.name],
          limit: ^quantity

      results = Repo.all(query, prefix: tenant)
      {user, results}
    end)
  end
end
