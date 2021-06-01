defmodule Edukator.Config.DefaultValue do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset

  schema "config_default_values" do
    field(:caption, :string)
    field(:class_name, :string)
    field(:attribute_name, :string)
    field(:default_value, :string)

    timestamps()
  end

  @doc false
  def changeset(default_value, attrs) do
    default_value
    |> cast(attrs, [:caption, :class_name, :attribute_name, :default_value])
    |> validate_required([:caption, :class_name, :attribute_name, :default_value])
  end
end
