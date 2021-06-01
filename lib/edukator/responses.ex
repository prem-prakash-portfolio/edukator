defmodule Edukator.Responses do
  @moduledoc """
  The Responses context.
  """

  import Ecto.Query, warn: false
  alias Edukator.Repo

  alias Edukator.Responses.Response

  def answer_question(args, tenant \\ "public") do
    attrs = process_args(args)
    where = attrs |> Map.take([:training_id, :exam_session_id, :question_id]) |> Map.to_list()

    case get_response_by(where, tenant) do
      %Response{} = response -> update_response!(response, attrs, tenant)
      nil -> create_response!(attrs, tenant)
    end
  end

  defp process_args(%{id: id, type: type} = args) do
    case type do
      "ExamSession" -> args |> Map.drop([:id, :type]) |> Map.put(:exam_session_id, id)
      "Training" -> args |> Map.drop([:id, :type]) |> Map.put(:training_id, id)
      _ -> nil
    end
  end

  @doc """
  Creates a response.

  ## Examples

      iex> create_response(%{field: value})
      {:ok, %Response{}}

      iex> create_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_response!(attrs \\ %{}, tenant \\ "public") do
    %Response{}
    |> Response.create_changeset(attrs)
    |> Repo.insert!(prefix: tenant)
  end

  @doc """
  Returns the list of responses.

  ## Examples

      iex> list_responses()
      [%Response{}, ...]

  """
  def list_responses do
    Repo.all(Response)
  end

  @doc """
  Gets a single response.

  Raises `Ecto.NoResultsError` if the Response does not exist.

  ## Examples

      iex> get_response!(123)
      %Response{}

      iex> get_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_response!(id), do: Repo.get!(Response, id)

  @doc """
  Gets a single response matching atttributes

  Raises `Ecto.NoResultsError` if the Response does not exist.

  ## Examples

      iex> get_response_by!([question_id: 123])
      %Response{}

      iex> get_response_by!([question_id: 55])
      ** (Ecto.NoResultsError)

  """
  def get_response_by(attrs, tenant \\ "public") do
    Response
    |> from(where: ^attrs)
    |> Repo.one(prefix: tenant)
  end

  @doc """
  Updates a response.

  ## Examples

      iex> update_response(response, %{field: new_value})
      {:ok, %Response{}}

      iex> update_response(response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_response!(%Response{} = response, attrs, tenant \\ "public") do
    response
    |> Response.update_changeset(attrs)
    |> Repo.update!(prefix: tenant)
  end

  @doc """
  Deletes a Response.

  ## Examples

      iex> delete_response(response)
      {:ok, %Response{}}

      iex> delete_response(response)
      {:error, %Ecto.Changeset{}}

  """
  def delete_response(%Response{} = response) do
    Repo.delete(response)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking response changes.

  ## Examples

      iex> change_response(response)
      %Ecto.Changeset{source: %Response{}}

  """
  def change_response(%Response{} = response) do
    Response.changeset(response, %{})
  end
end
