defmodule Edukator.ValidationHelpers do
  @moduledoc """
  This module helps to validate changesets
  """

  import Ecto.Changeset, only: [validate_format: 4, validate_change: 3]
  import EdukatorWeb.Gettext, only: [gettext: 1]

  def validate_email(changeset, field) do
    changeset
    |> validate_format(field, email_format(), message: gettext("is invalid"))
  end

  def validate_document(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, value ->
      if Brcpfcnpj.cpf_valid?(%Cpf{number: value}) do
        []
      else
        [{field, options[:message] || "is invalid"}]
      end
    end)
  end

  defp email_format do
    ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/
  end
end
