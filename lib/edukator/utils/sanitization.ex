defmodule Edukator.Sanitization do
  @moduledoc """
  This module helps to sanitize data input
  """

  import Ecto.Changeset, only: [update_change: 3, get_change: 2]

  def stringify(changeset, fields) when is_list(fields) do
    Enum.reduce(fields, changeset, &stringify(&2, &1))
  end

  def stringify(changeset, field) do
    case get_change(changeset, field) do
      nil ->
        changeset

      _ ->
        update_change(changeset, field, fn value -> to_string(value) end)
    end
  end

  def stringify_map(changeset, fields) when is_list(fields) do
    Enum.reduce(fields, changeset, &stringify_map(&2, &1))
  end

  def stringify_map(changeset, field) do
    case get_change(changeset, field) do
      nil ->
        changeset

      _ ->
        update_change(changeset, field, &Edukator.MapHelpers.stringify_keys(&1))
    end
  end

  def trim(changeset, field) do
    case get_change(changeset, field) do
      nil ->
        changeset

      _ ->
        update_change(changeset, field, &String.trim/1)
    end
  end

  def squish(changeset, fields) when is_list(fields) do
    Enum.reduce(fields, changeset, &squish(&2, &1))
  end

  def squish(changeset, field) when is_atom(field) do
    case get_change(changeset, field) do
      nil ->
        changeset

      _ ->
        update_change(changeset, field, &squish/1)
    end
  end

  defp squish(value) do
    value
    |> String.replace(~r/\s+/, "")
    |> String.trim()
  end

  def downcase(changeset, fields) when is_list(fields) do
    Enum.reduce(fields, changeset, &downcase(&2, &1))
  end

  def downcase(changeset, field) when is_atom(field) do
    case get_change(changeset, field) do
      nil ->
        changeset

      _ ->
        update_change(changeset, field, &String.downcase/1)
    end
  end
end
