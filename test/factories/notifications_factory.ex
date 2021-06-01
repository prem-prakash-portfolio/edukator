defmodule Edukator.NotificationsFactory do
  @moduledoc """
  Factory for modules inside the `Notifications` context
  """

  defmacro __using__(_opts) do
    quote do
      def notification_type_factory do
        %Edukator.Notifications.NotificationType{
          available_placeholders: "user.name",
          channels: ["email", "webapp_notification_feed", "app_push_notification"],
          description: "Mensagem enviada quando usuário criar a conta",
          identifier: "welcome_message",
          name: "Mensagem de Boas Vindas",
          title_template: "Bem vindo à plataforma de questões, {{user.name}}",
          body_template: "Mensagem de boas vindas para {{user.name}}",
          user_can_optin_out: false
        }
      end

      def notification_message_factory do
        %Edukator.Notifications.NotificationMessage{
          raw_body: "Mensagem de boas vindas para fulano",
          raw_title: "Bem vindo à plataforma de questões",
          viewed_at: DateTime.utc_now(),
          user: build(:user),
          notification_type: build(:notification_type)
        }
      end
    end
  end
end
