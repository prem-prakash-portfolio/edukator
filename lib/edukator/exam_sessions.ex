defmodule Edukator.ExamSessions do
  @moduledoc """
  The ExamSessions context.
  """

  import Ecto.Query, warn: false
  alias Edukator.Repo

  alias Edukator.ExamSessions.ExamSession

  @doc """
  Gets a single exam_session.

  Raises `Ecto.NoResultsError` if the Exam session does not exist.

  ## Examples

      iex> get_exam_session!(123)
      %ExamSession{}

      iex> get_exam_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_exam_session(id, user_id, tenant \\ "public") do
    query = from e in ExamSession, where: e.id == ^id and e.user_id == ^user_id
    Repo.one(query, prefix: tenant)
  end

  def get_exam_session!(id, user_id, tenant \\ "public") do
    query = from e in ExamSession, where: e.id == ^id and e.user_id == ^user_id
    Repo.one!(query, prefix: tenant)
  end

  @doc """
  Creates a exam_session.

  ## Examples

      iex> create_exam_session(%{field: value})
      {:ok, %ExamSession{}}

      iex> create_exam_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_exam_session(exam_id, user, tenant \\ "public") do
    # to-do find an existing unfinished exam session of today before creating a new one
    es =
      %ExamSession{}
      |> ExamSession.create_changeset(%{user_id: user.id, exam_id: exam_id})
      |> Repo.insert!(prefix: tenant)

    exam = es |> Repo.preload(:exam) |> Map.get(:exam)
    {:ok, %{exam | exam_sessions: [es]}}
  end

  @doc """
  Updates a exam_session.

  ## Examples

      iex> update_exam_session(exam_session, %{field: new_value})
      {:ok, %ExamSession{}}

      iex> update_exam_session(exam_session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_exam_session(%ExamSession{} = exam_session, attrs) do
    exam_session
    |> ExamSession.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ExamSession.

  ## Examples

      iex> delete_exam_session(exam_session)
      {:ok, %ExamSession{}}

      iex> delete_exam_session(exam_session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_exam_session(args, current_user, tenant \\ "public") do
    args.id
    |> get_exam_session!(current_user.id, tenant)
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking exam_session changes.

  ## Examples

      iex> change_exam_session(exam_session)
      %Ecto.Changeset{source: %ExamSession{}}

  """
  def change_exam_session(%ExamSession{} = exam_session) do
    ExamSession.changeset(exam_session, %{})
  end

  def update_correct_questions_count(%ExamSession{} = exam_session) do
    attrs = %{correct_questions_count: exam_session.correct_questions_count + 1}
    exam_session
    |> Repo.preload([:user, :exam])
    |> ExamSession.changeset(attrs)
    |> Repo.update()
  end
end
