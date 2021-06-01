defmodule Edukator.Notifications.Triggers.WeeklySummary do
  @moduledoc """
  Send notifications to user with summary
  """
  alias Edukator.Repo
  import Ecto.Query

  alias Edukator.Responses.Response
  alias Edukator.Notifications.NotificationSender

  def run(notification_type_identifier, tenant \\ "public") do
    # TODO run each user in a Elixir Task to avoid long running process,
    # to run in paralell and to retry or not in case of errors
    tenant
    |> users_with_activity_in_current_week()
    |> Enum.each(fn %{user: user, week_total_responses: week_total_responses} ->
      NotificationSender.maybe_send(user, notification_type_identifier, %{
        week_total_responses: week_total_responses
      })
    end)
  end

  defp users_with_activity_in_current_week(tenant) do
    date_start = now() |> Timex.beginning_of_week() |> Timex.to_datetime()
    date_end = now() |> Timex.end_of_week() |> Timex.to_datetime()

    query =
      from r in Response,
        join: es in assoc(r, :exam_session),
        join: u in assoc(es, :user),
        where: ^date_start <= r.updated_at and r.updated_at <= ^date_end,
        select: %{user: u, week_total_responses: fragment("COUNT(*)")},
        group_by: [1],
        having: fragment("COUNT(*) > 0")

    Repo.all(query, prefix: tenant)
  end

  defp now, do: Timex.now("America/Sao_Paulo")
end
