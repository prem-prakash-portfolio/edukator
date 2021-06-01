defmodule EdukatorWeb.Resolvers.SessionResolver do
  @moduledoc false
  alias Edukator.Sessions

  def show(_parent, args, %{
        context: %{current_user: current_user, tenant: tenant}
      }) do
    attrs = Map.put(args, :user_id, current_user.id)
    {:ok, Sessions.get_session(attrs, tenant)}
  end

  def show(_parent, _args, _context), do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def list_sessions(_parent, args, %{
        context: %{current_user: current_user, tenant: tenant}
      }) do
    {:ok, Sessions.list(args, current_user, tenant)}
  end

  def list_sessions(_parent, _args, _context),
    do: {:error, %{key: "auth", messages: "Unauthenticated"}}
end
