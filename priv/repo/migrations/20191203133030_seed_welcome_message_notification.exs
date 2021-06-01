defmodule Edukator.Repo.Migrations.SeedWelcomeMessageNotification do
  use Ecto.Migration

  alias Edukator.Notifications.NotificationType
  alias Edukator.Repo

  def change do
    alter table(:notification_types) do
      modify(:body_template, :text)
    end

    alter table(:notification_messages) do
      modify(:raw_body, :text)
    end

    flush()

    body_template = """
    <p>Olá, {{ user.name }}</p>
    <p>Sua conta na <strong>plataforma de questões</strong> da Folha Dirigida Online foi criada com sucesso!
      Clique no link abaixo para acessar a plataforma e começar a estudar:</p>
      <a href="https://questoes.folhadirigida.com.br">questoes.folhadirigida.com.br</a>
    <p>Não esqueça de salvar o link nos favoritos para acessar depois.E se quiser falar conosco,
    é só escrever para <a href="mailto:relacionamento@folhadirigida.com.br">relacionamento@folhadirigida.com.br</a>.</p>
    <p>Bons estudos!</p>
    <p>Equipe Folha Dirigida Online</p>
    """

    args = %{
      available_placeholders: "user.name",
      channels: ["email", "webapp_notification_feed"],
      description: "Mensagem enviada quando usuário criar a conta",
      identifier: "welcome_message",
      name: "Mensagem de Boas Vindas",
      title_template: "Seja bem-vindo!",
      body_template: body_template,
      user_can_optin_out: false
    }

    %NotificationType{}
    |> NotificationType.changeset(args)
    |> Repo.insert!()
  end
end
