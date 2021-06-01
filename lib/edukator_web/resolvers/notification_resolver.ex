defmodule EdukatorWeb.Resolvers.NotificationResolver do
  @moduledoc false
  alias Edukator.Notifications

  def list(_parent, _args, %{context: %{current_user: user, tenant: tenant}}) do
    {:ok, Notifications.list_notifications(user.id, tenant)}
  end

  def list(_parent, _args, _context), do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def mark_as_read(_parent, args, %{
        context: %{current_user: current_user, tenant: tenant}
      }) do
    Notifications.mark_notification_as_read(args[:id], current_user.id, tenant)
  end

  def mark_as_read(_parent, _args, _context),
    do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def mark_as_unread(_parent, args, %{
        context: %{current_user: current_user, tenant: tenant}
      }) do
    Notifications.mark_notification_as_unread(args[:id], current_user.id, tenant)
  end

  def mark_as_unread(_parent, _args, _context),
    do: {:error, %{key: "auth", messages: "Unauthenticated"}}
end
