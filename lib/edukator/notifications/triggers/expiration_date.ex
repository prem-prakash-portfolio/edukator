defmodule Edukator.Notifications.Triggers.ExpirationDate do
  @moduledoc """
  Send notifications to user related to expiration date
  """
  alias Edukator.Repo
  import Ecto.Query

  alias Edukator.Accounts.User
  alias Edukator.Notifications.NotificationSender

  def run(notification_type_identifier, days, tenant \\ "public") do
    # TODO run each user in a Elixir Task to avoid long running process,
    # to run in paralell and to retry or not in case of errors
    additional_data = %{days_to_trial_expiration: days}

    days
    |> users_with_trial_expiration_in(tenant)
    |> Enum.each(fn user ->
      NotificationSender.maybe_send(user, notification_type_identifier, additional_data)
    end)
  end

  defp users_with_trial_expiration_in(days, tenant) do
    date = "America/Sao_Paulo" |> Timex.now() |> Timex.to_date() |> Timex.shift(days: days)
    query = from u in User, where: u.account_type == "TRIAL" and u.trial_expiration_date == ^date
    Repo.all(query, prefix: tenant)
  end
end
