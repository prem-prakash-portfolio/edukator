defmodule Edukator.Admin.Campus do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset

  schema "admin_campus" do
    field(:name, :string)
    field(:domain, :string)

    timestamps()
  end

  @doc false
  def changeset(campus, attrs) do
    campus
    |> cast(attrs, [:name, :domain])
    |> validate_required([:name, :domain])
  end
end
