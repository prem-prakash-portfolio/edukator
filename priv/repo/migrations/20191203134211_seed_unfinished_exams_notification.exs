defmodule Edukator.Repo.Migrations.SeedUnfinishedExamsNotification do
  use Ecto.Migration
  alias Edukator.Notifications.NotificationType
  alias Edukator.Repo

  def change do
    body_template = """
    <p>Olá, {{ user.name }}</p>
    <p>Você não terminou as provas:</p>
    <ul>
    {% for exam in exams %}
    <li>{{ exam.name }}</li>
    {% endfor %}
    </ul>
    <p>Bons estudos!</p>
    <p>Equipe Folha Dirigida Online</p>
    """

    args = %{
      available_placeholders: "user.name, exams = [name: name]",
      channels: ["email", "webapp_notification_feed"],
      description: "Mensagem enviada para informar de provas inacabadas",
      identifier: "unfinished_exam",
      name: "Mensagem provas inacabadas",
      title_template: "Você possui provas inacabadas",
      body_template: body_template,
      user_can_optin_out: false
    }

    %NotificationType{}
    |> NotificationType.changeset(args)
    |> Repo.insert!()
  end
end
