defmodule Edukator.Notifications.NotificationSenderTest do
  use Edukator.DataCase
  import Edukator.Factory

  alias Edukator.Notifications.NotificationSender
  alias Edukator.Notifications.NotificationMessage
  alias Edukator.Repo

  describe "maybe_send/3" do
    test "should create message" do
      user = insert(:user)
      notification_type = insert(:notification_type, identifier: "welcome_message")

      get_notification_message = fn ->
        Repo.get_by(NotificationMessage,
          recipient_user_id: user.id,
          notification_type_id: notification_type.id
        )
      end

      assert get_notification_message.() == nil

      NotificationSender.maybe_send(user, "welcome_message", %{user: user})

      notification_message = get_notification_message.()

      assert notification_message.recipient_user_id == user.id
      assert notification_message.notification_type_id == notification_type.id
    end
  end
end
