defmodule Edukator.Notifications do
  alias Edukator.Repo
  alias Edukator.Notifications.{NotificationMessage, NotificationType}
  import Ecto.Query, only: [from: 2]

  def get_notification_type(clauses, tenant \\ "public") do
    Repo.get_by!(NotificationType, clauses, prefix: tenant)
  end

  def create_notification_message(attrs \\ %{}, tenant \\ "public") do
    %NotificationMessage{}
    |> NotificationMessage.changeset(attrs)
    |> Repo.insert(prefix: tenant)
  end

  def list_notifications(user_id, channels \\ ["webapp_notification_feed"], tenant \\ "public") do
    query =
      from n in NotificationMessage,
        where: n.recipient_user_id == ^user_id,
        join: mt in assoc(n, :notification_type),
        where: fragment("? && ?", mt.channels, ^channels),
        order_by: [desc: n.created_at]

    {:ok, Repo.all(query, prefix: tenant)}
  end

  def mark_notification_as_read(notification_message_id, user_id, tenant \\ "public") do
    from(n in NotificationMessage,
      where: n.recipient_user_id == ^user_id and n.id == ^notification_message_id
    )
    |> Repo.update_all(
      set: [read_at: DateTime.utc_now(), updated_at: DateTime.utc_now()],
      prefix: tenant
    )
  end

  def mark_notification_as_unread(notification_message_id, user_id, tenant \\ "public") do
    from(n in NotificationMessage,
      where: n.recipient_user_id == ^user_id and n.id == ^notification_message_id
    )
    |> Repo.update_all(set: [read_at: nil, updated_at: DateTime.utc_now()], prefix: tenant)
  end
end
