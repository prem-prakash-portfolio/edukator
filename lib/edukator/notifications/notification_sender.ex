defmodule Edukator.Notifications.NotificationSender do
  @moduledoc false

  alias Edukator.Accounts.User
  alias Edukator.Notifications
  alias Edukator.Notifications.{DeliverEmailNotification, NotificationType, NotificationMessage}

  def maybe_send(
        %User{notification_settings: notification_settings} = user,
        notification_type_identifier,
        additional_data \\ %{}
      ) do
    notification_type =
      Notifications.get_notification_type(identifier: notification_type_identifier)

    active_for_user =
      notification_settings
      |> Enum.find(%{}, &(&1.notification_type_id == notification_type.id))
      |> Map.get(:active, true)

    if active_for_user do
      additional_data = Map.merge(additional_data, %{user: user})
      send_notification(user, notification_type, additional_data)
    end
  end

  def send_notification(
        user,
        %NotificationType{channels: channels} = notification_type,
        additional_data \\ %{}
      ) do
    {:ok, notification_message} =
      generate_notification_message(user, notification_type, additional_data)

    Enum.each(channels, fn channel ->
      send_notification_via_channel(channel, notification_message)
    end)
  end

  def generate_notification_message(user, notification_type, additional_data \\ %{}) do
    attrs = %{
      notification_type: notification_type,
      user: user,
      additional_data: additional_data,
      raw_title: render_template(notification_type.title_template, additional_data),
      raw_body: render_template(notification_type.body_template, additional_data)
    }

    Notifications.create_notification_message(attrs)
  end

  def render_template(template, data) do
    data = Edukator.MapHelpers.stringify_keys(data)
    {:ok, template} = Solid.parse(template)
    template |> Solid.render(data) |> to_string
  end

  def send_notification_via_channel(
        "email" = _channel,
        %NotificationMessage{} = notification_message
      ) do
    DeliverEmailNotification.send(notification_message)
  end

  def send_notification_via_channel("webapp_notification_feed" = _channel, _notification_message) do
    # Do nothing now, because notifications are pulled on demand.
    # In the future could use websockets / graphql to send message to webapp.
  end

  def send_notification_via_channel("app_push_notification" = _channel, _notification_message) do
    # Do nothing now, because notifications are pulled on demand.
    # In the future could use websockets / graphql to send message to mobile app.
  end

  def send_notification_via_channel(_channel, _notification_message) do
  end
end
