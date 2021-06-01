defmodule Edukator.Trainings do
  @moduledoc """
  The Trainings context.
  """

  import Ecto.Query, warn: false
  alias Edukator.Repo

  alias Edukator.QuestionFilter
  alias Edukator.QuestionFilterQuery
  alias Edukator.Trainings.Training

  @doc """
  Creates a training.

  ## Examples

      iex> create_training(%{field: value})
      {:ok, %Training{}}

      iex> create_training(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_training(
        %{size: questions_quantity, name: name, filters: filters} = _args,
        user,
        tenant
      )
      when is_integer(questions_quantity) do
    filters = QuestionFilter.process_filters(filters)

    filters
    |> QuestionFilterQuery.build_query(user.id)
    |> get_first_random_question_id(tenant)
    |> insert_training(name, filters, questions_quantity, user, tenant)
  end

  defp get_first_random_question_id(filter_query, tenant) do
    query = from q in filter_query, select: q.id, order_by: fragment("random()"), limit: 1

    query
    |> exclude(:distinct)
    |> Repo.one(prefix: tenant)
  end

  defp insert_training(question_id, name, filters, questions_quantity, user, tenant) do
    %Training{}
    |> Training.create_changeset(%{
      user_id: user.id,
      questions_count: questions_quantity,
      name: name,
      filter: filters,
      training_questions: [%{question_id: question_id, position: 1}]
    })
    |> Repo.insert(prefix: tenant)
  end

  @doc """
  Returns the list of trainings.

  ## Examples

      iex> list_trainings()
      [%Training{}, ...]

  """
  def list_trainings do
    Repo.all(Training)
  end

  @doc """
  Gets a single training.

  Raises `Ecto.NoResultsError` if the Training does not exist.

  ## Examples

      iex> get_training!(123)
      %Training{}

      iex> get_training!(456)
      ** (Ecto.NoResultsError)

  """
  def get_training!(id, user_id, tenant \\ "public") do
    query = from t in Training, where: t.id == ^id and t.user_id == ^user_id
    Repo.one!(query, prefix: tenant)
  end

  @doc """
  Updates a training.

  ## Examples

      iex> update_training(training, %{field: new_value})
      {:ok, %Training{}}

      iex> update_training(training, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_training(%Training{} = training, attrs) do
    training
    |> Training.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Training.

  ## Examples

      iex> delete_training(training)
      {:ok, %Training{}}

      iex> delete_training(training)
      {:error, %Ecto.Changeset{}}

  """
  def delete_training(args, current_user, tenant \\ "public") do
    args.id
    |> get_training!(current_user.id, tenant)
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking training changes.

  ## Examples

      iex> change_training(training)
      %Ecto.Changeset{source: %Training{}}

  """
  def change_training(%Training{} = training) do
    Training.changeset(training, %{})
  end
end
