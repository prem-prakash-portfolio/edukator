defmodule Edukator.Events do
  @moduledoc false
  alias Edukator.Repo
  alias Edukator.Events.Event

  alias Edukator.Accounts.User

  def track_event(%User{} = user, %{} = params, tenant \\ "public") do
    params = Map.put(params, "user", user)
    params = Map.put(params, "value", to_string(params["value"]))

    %Event{}
    |> Event.changeset(params)
    |> Repo.insert!(prefix: tenant)
  end
end
