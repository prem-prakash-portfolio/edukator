defmodule Edukator.Notifications.DeliverEmailNotification do
  @moduledoc """
  Send email notification from a NotificationMessage
  """
  alias Edukator.Notifications.NotificationMessage
  alias Edukator.Mailer
  alias Edukator.Mailer.NotificationMailer
  alias Edukator.Accounts

  def send(%NotificationMessage{raw_title: title, raw_body: body, recipient_user_id: user_id}) do
    user_id
    |> Accounts.get_user_by_id()
    |> case do
      {:ok, %{name: to_name, email: to_email}} ->
        %{to_name: to_name, to_email: to_email, title: title, body: body}
        |> NotificationMailer.message()
        |> Mailer.deliver()

      _ ->
        nil
    end
  end
end
