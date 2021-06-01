defmodule Edukator.Notifications.Triggers.LastActivity do
  @moduledoc """
  Send notifications to user related to expiration date
  """
  alias Edukator.Repo
  import Ecto.Query

  alias Edukator.Events.Event
  alias Edukator.Notifications.NotificationSender

  def run(notification_type_identifier, days, tenant \\ "public") do
    # TODO run each user in a Elixir Task to avoid long running process,
    # to run in paralell and to retry or not in case of errors
    additional_data = %{days_after_last_activity: days}

    days
    |> users_last_activity(tenant)
    |> Enum.each(fn %{user: user} ->
      NotificationSender.maybe_send(user, notification_type_identifier, additional_data)
    end)
  end

  def users_last_activity(days, tenant) do
    date =
      "America/Sao_Paulo"
      |> Timex.now()
      |> Timex.shift(days: -days)
      |> Timex.beginning_of_day()
      |> Timex.to_date()

    query =
      from e in Event,
        join: u in assoc(e, :user),
        select: %{user: u, date: fragment("MAX(?)", e.created_at)},
        group_by: [1]

    Repo.all(query, prefix: tenant)
    |> Enum.filter(fn x -> Date.compare(x.date, date) == :lt end)
  end
end
