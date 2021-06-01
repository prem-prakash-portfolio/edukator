defmodule Edukator.Repo.Migrations.SeedWeeklySummaryNotification do
  use Ecto.Migration

  alias Edukator.Notifications.NotificationType
  alias Edukator.Repo

  def change do
    body_template = """
    <p>Olá, {{ user.name }}</p>
    <p>Esta semana você respondeu {{ week_total_responses }} questões. Parabéns!</p>
    <p>Bons estudos!</p>
    <p>Equipe Folha Dirigida Online</p>
    """

    args = %{
      available_placeholders: "user.name, week_total_responses",
      channels: ["email", "webapp_notification_feed"],
      description: "Mensagem com resumo da semana",
      identifier: "weekly_summary",
      name: "Mensagem com resumo da semana",
      title_template: "Veja como foi seu rendimento esta semana",
      body_template: body_template,
      user_can_optin_out: false
    }

    %NotificationType{}
    |> NotificationType.changeset(args)
    |> Repo.insert!()
  end
end
