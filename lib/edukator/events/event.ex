defmodule Edukator.Events.Event do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset

  alias Edukator.Accounts.User

  schema "events" do
    field :category, :string
    field :action, :string
    field :label, :string
    field :value, :string
    field :properties, :map
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(event, %{"user" => user} = attrs) do
    event
    |> cast(attrs, [:category, :action, :label, :value, :properties])
    |> put_assoc(:user, user)
    |> validate_required([:category, :action, :label, :properties])
  end
end
