defmodule Edukator.Notifications.NotificationSetting do
  @moduledoc """
  Notification settings of user
  """

  use Edukator.Schema
  import Ecto.Changeset
  @primary_key false

  alias Edukator.Notifications.NotificationType

  embedded_schema do
    belongs_to(:notification_type, NotificationType)
    field(:active, :boolean, default: true)
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:active])
    |> cast_assoc(:notification_type, required: true)
    |> validate_required([:active])
  end
end
