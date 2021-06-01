defmodule Edukator.Notifications.DeliverEmailNotificationTest do
  use Edukator.DataCase
  import Edukator.Factory
  alias Edukator.Notifications.DeliverEmailNotification

  describe "send/3" do
    test "should send email" do
      user = insert(:user)
      subject = "Bem vindo à plataforma de questões"

      notification_message = insert(:notification_message, raw_title: subject, user: user)

      DeliverEmailNotification.send(notification_message)

      assert Swoosh.Adapters.Local.Storage.Memory.all() |> Enum.any?(&(&1.subject == subject))
    end
  end
end
