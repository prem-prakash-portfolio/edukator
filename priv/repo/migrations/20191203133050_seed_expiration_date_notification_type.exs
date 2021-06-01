defmodule Edukator.Repo.Migrations.SeedExpirationDateNotificationType do
  use Ecto.Migration
  alias Edukator.Notifications.NotificationType
  alias Edukator.Repo

  def change do
    body_template = """
    <p>Olá, {{ user.name }}</p>
    <p>Seu período de testes termina em {{ days_to_trial_expiration }} dias!</p>
    <p>Gostou, assine agora!</p>
    <p>Bons estudos!</p>
    <p>Equipe Folha Dirigida Online</p>
    """

    args = %{
      available_placeholders: "user.name, days_to_trial_expiration",
      channels: ["email", "webapp_notification_feed"],
      description: "Mensagem enviada quando período Trial está prestes a expirar",
      identifier: "trial_close_to_expiration",
      name: "Mensagem de proximidade da expiração do Trial",
      title_template: "Está gostando? Assine",
      body_template: body_template,
      user_can_optin_out: false
    }

    %NotificationType{}
    |> NotificationType.changeset(args)
    |> Repo.insert!()
  end
end
