defmodule EdukatorWeb.Schema.NotificationTypes do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias DeliriumTremex.Middleware.HandleErrors
  alias EdukatorWeb.Resolvers

  @desc "A notification"
  object :notification do
    field(:id, :id)
    field(:title, :string)
    field(:body, :string)
    field(:read, :boolean)
  end

  object :notification_queries do
    @desc "List all notifications"
    field :notifications, list_of(:notification) do
      resolve(&Resolvers.NotificationResolver.list/3)
      middleware(HandleErrors)
    end
  end

  object :notification_mutations do
    @desc "Mark Notification as Read"
    field :mark_as_read, :notification do
      arg(:id, non_null(:id))
      resolve(&Resolvers.NotificationResolver.mark_as_read/3)
      middleware(HandleErrors)
    end

    @desc "Mark Notification as Unread"
    field :mark_as_unread, :notification do
      arg(:id, non_null(:id))
      resolve(&Resolvers.NotificationResolver.mark_as_read/3)
      middleware(HandleErrors)
    end
  end
end
