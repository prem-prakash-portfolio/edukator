defmodule Edukator.Mailer.AccountsMailer do
  @moduledoc false
  use Phoenix.Swoosh,
    view: EdukatorWeb.AccountsMailerView,
    layout: {EdukatorWeb.LayoutView, :mailer}

  alias EdukatorWeb.Router.Helpers, as: Routes

  def new_account_welcome_message(user, tenant \\ "public") do
    new()
    |> from(from())
    |> to(user.email)
    |> subject("Seja bem-vindo!")
    |> render_body("new_account_welcome_message.html", %{user: user, logo_url: logo_url(tenant)})
  end

  def reset_password_instructions(user, reset_password_token, tenant \\ "public") do
    reset_password_link =
      Routes.app_url(EdukatorWeb.Endpoint, :index) <> "trocar-senha/" <> reset_password_token

    new()
    |> from(from())
    |> to(user.email)
    |> subject("Instruções de troca de senha")
    |> render_body("reset_password_instructions.html", %{
      user: user,
      reset_password_link: reset_password_link,
      logo_url: logo_url(tenant)
    })
  end

  defp logo_url(_tenant) do
    Routes.static_url(EdukatorWeb.Endpoint, "/images/folha-dirigida-logo.png")
  end

  defp from do
    email = System.get_env("EMAIL_FROM") || "conta@dominio.com"
    {"Folha Dirigida Online", email}
  end
end
