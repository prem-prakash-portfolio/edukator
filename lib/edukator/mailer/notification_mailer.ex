defmodule Edukator.Mailer.NotificationMailer do
  @moduledoc false
  import Swoosh.Email

  def message(%{to_name: to_name, to_email: to_email, title: title, body: body}) do
    new()
    |> to({to_name, to_email})
    |> from(from())
    |> subject(title)
    |> html_body(Premailex.to_inline_css(body))
    |> text_body(Premailex.to_text(body))
  end

  defp from do
    email = System.get_env("EMAIL_FROM") || "conta@dominio.com"
    {"Folha Dirigida Online", email}
  end
end
