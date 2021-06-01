defmodule Edukator.Notifications.NotificationMessage do
  @moduledoc """
  Notification message sent to user
  """
  use Edukator.Schema
  import Ecto.Changeset

  alias Edukator.Accounts.User
  alias Edukator.Notifications.NotificationType

  schema "notification_messages" do
    field :additional_data, :map
    field :deleted_at, :utc_datetime
    field :raw_body, :string
    field :raw_title, :string
    field :viewed_at, :utc_datetime
    belongs_to(:user, User, foreign_key: :recipient_user_id)
    belongs_to(:notification_type, NotificationType)

    timestamps()
  end

  @doc false
  def changeset(notification_message, %{user: user, notification_type: notification_type} = attrs) do
    notification_message
    |> cast(attrs, [:additional_data, :raw_body, :raw_title, :viewed_at, :deleted_at])
    |> put_assoc(:user, user)
    |> put_assoc(:notification_type, notification_type)
    |> validate_required([:additional_data, :raw_body, :raw_title])
  end
end
