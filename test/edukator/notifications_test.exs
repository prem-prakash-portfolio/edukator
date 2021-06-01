defmodule Edukator.NotificationsTest do
  use Edukator.DataCase
  import Edukator.Factory

  alias Edukator.Notifications

  describe "list_notifications/3" do
    test "should list user notifications" do
      user = insert(:user)
      notification_message = insert(:notification_message, user: user)

      {:ok, notification_messages} = Notifications.list_notifications(user.id)
      assert Enum.any?(notification_messages, &(&1.id == notification_message.id))
    end

    test "should not list user notifications of another channel" do
      user = insert(:user)
      notification_type = insert(:notification_type, channels: ["email"])

      notification_message =
        insert(:notification_message, notification_type: notification_type, user: user)

      {:ok, notification_messages} =
        Notifications.list_notifications(user.id, ["webapp_notification_feed"])

      refute Enum.any?(notification_messages, &(&1.id == notification_message.id))
    end
  end
end
