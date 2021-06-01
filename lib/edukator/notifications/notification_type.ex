defmodule Edukator.Notifications.NotificationType do
  @moduledoc """
  NotificationType is a template for a notification message.
  It has a *identifier* that allows triggers to load the template string and replace placeholders
  with custom data to create the message to send to the user.

  channels [“email”, “webapp_notification_feed”, “app_push_notification”]

  available_placeholders is a string field to inform admin users of which fields are available
  to be used on the template

  templates uses Liquid template language ( https://shopify.github.io/liquid/ )
  """
  use Edukator.Schema
  import Ecto.Changeset

  schema "notification_types" do
    field :available_placeholders, :string
    field :channels, {:array, :string}
    field :description, :string
    field :identifier, :string
    field :name, :string
    field :title_template, :string
    field :body_template, :string
    field :user_can_optin_out, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(notification_type, attrs) do
    notification_type
    |> cast(attrs, [
      :name,
      :description,
      :identifier,
      :title_template,
      :body_template,
      :available_placeholders,
      :user_can_optin_out,
      :channels
    ])
    |> validate_required([
      :name,
      :description,
      :identifier,
      :title_template,
      :body_template,
      :available_placeholders,
      :user_can_optin_out,
      :channels
    ])
    |> unique_constraint(:identifier, name: "index_notification_types_on_identifier")
    |> check_template([:title_template, :body_template])
  end

  defp check_template(changeset, fields) when is_list(fields) do
    Enum.reduce(fields, changeset, &check_template(&2, &1))
  end

  defp check_template(changeset, field) when is_atom(field) do
    changeset
    |> get_change(field)
    |> Solid.parse()
    |> case do
      {:ok, _} -> changeset
      _ -> add_error(changeset, field, "Template inválido")
    end
  end
end
