defmodule Edukator.Repo.Migrations.SeedLastAccessNotification do
  use Ecto.Migration

  alias Edukator.Notifications.NotificationType
  alias Edukator.Repo

  def change do
    body_template = """
    <p>Olá, {{ user.name }}</p>
    <p>Estamos com saudades, faz tempo que você não vem nos visitar!</p>
    <p>Bons estudos!</p>
    <p>Equipe Folha Dirigida Online</p>
    """

    args = %{
      available_placeholders: "user.name",
      channels: ["email", "webapp_notification_feed"],
      description: "Mensagem enviada quando usuário está sem acessar",
      identifier: "last_access",
      name: "Mensagem enviada quando usuário está sem acessar",
      title_template: "Estamos com saudade",
      body_template: body_template,
      user_can_optin_out: false
    }

    %NotificationType{}
    |> NotificationType.changeset(args)
    |> Repo.insert!()
  end
end
