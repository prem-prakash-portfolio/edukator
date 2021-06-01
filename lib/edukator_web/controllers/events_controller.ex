defmodule EdukatorWeb.EventsController do
  use EdukatorWeb, :controller
  import Plug.Conn, only: [put_status: 2, get_req_header: 2]
  alias Edukator.Guardian
  alias Edukator.Events

  def create(conn, params) do
    tenant = conn.assigns.raw_current_tenant

    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user, _claims} <- Guardian.resource_from_token(token) do
      if Mix.env() == :prod do
        Sentry.Context.set_user_context(user)
      end

      Events.track_event(user, params, tenant)
    end

    conn |> put_status(:ok) |> json(%{})
  end
end
