defmodule Edukator.Repo.Migrations.SeedExpirationDateTrialExpiredNotification do
  use Ecto.Migration

  alias Edukator.Notifications.NotificationType
  alias Edukator.Repo

  def change do
    body_template = """
    <p>Olá, {{ user.name }}</p>
    <p>Seu período de testes terminou!</p>
    <p>Gostou, assine agora!</p>
    <p>Bons estudos!</p>
    <p>Equipe Folha Dirigida Online</p>
    """

    args = %{
      available_placeholders: "user.name, days_to_trial_expiration",
      channels: ["email", "webapp_notification_feed"],
      description: "Mensagem enviada quando período Trial expirou",
      identifier: "trial_expired",
      name: "Mensagem de expiração do Trial",
      title_template: "Seu período de testes terminou, assine agora",
      body_template: body_template,
      user_can_optin_out: false
    }

    %NotificationType{}
    |> NotificationType.changeset(args)
    |> Repo.insert!()
  end
end
