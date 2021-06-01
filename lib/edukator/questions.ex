defmodule Edukator.Questions do
  @moduledoc """
  The Questions context.
  """

  import Ecto.Query, warn: false
  alias Edukator.Repo

  alias Edukator.Exams.ExamQuestion
  alias Edukator.ExamSessions.ExamSession
  alias Edukator.Questions.{Question, Tag, Comment, Teacher}
  alias Edukator.Responses.Response
  alias Edukator.Trainings.{Training, TrainingQuestion}

  def list_tags(question, tenant \\ "public") do
    query =
      from t in Tag, join: qt in assoc(t, :question_tags), where: qt.question_id == ^question.id

    query
    |> Repo.all(prefix: tenant)
    |> Enum.group_by(&("#{&1.kind}s" |> String.downcase() |> String.to_atom()))
  end

  def get_question!(args, tenant \\ "public")

  def get_question!(%{id: id, type: type, user_id: user_id} = args, tenant) do
    args =
      case type do
        "ExamSession" ->
          query = from e in ExamSession, where: e.id == ^id and e.user_id == ^user_id
          exam_session = Repo.one!(query, prefix: tenant)
          args |> Map.drop([:id, :type, :user_id]) |> Map.put(:exam_session, exam_session)

        "Training" ->
          query = from t in Training, where: t.id == ^id and t.user_id == ^user_id
          training = Repo.one!(query, prefix: tenant)
          args |> Map.drop([:id, :type, :user_id]) |> Map.put(:training, training)

        _ ->
          nil
      end

    get_question!(args, tenant)
  end

  def get_question!(%{exam_session: exam_session, position: position}, tenant) do
    query =
      from q in exam_session_question_query(exam_session),
        limit: 1,
        offset: ^(position - 1)

    query |> Repo.one!(prefix: tenant) |> Repo.preload(:question_alternatives)
  end

  def get_question!(%{training: training, position: position}, tenant) do
    query =
      from q in training_question_query(training),
        limit: 1,
        offset: ^(position - 1)

    query |> Repo.one!(prefix: tenant) |> Repo.preload(:question_alternatives)
  end

  def get_comment!(%{id: id}, tenant) do
    query = from c in Comment, where: c.question_id == ^id

    query |> Repo.one(prefix: tenant)
  end

  def get_teacher!(%{teacher_id: teacher_id}, tenant) do
    query = from t in Teacher, where: t.id == ^teacher_id

    query |> Repo.one(prefix: tenant)
  end

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions(%{exam_session: exam_session}, tenant) do
    exam_session
    |> exam_session_question_query()
    |> Repo.all(prefix: tenant)
    |> Repo.preload(:question_alternatives)
  end

  def list_questions(%{training: training}, tenant) do
    training
    |> training_question_query()
    |> Repo.all(prefix: tenant)
    |> Repo.preload(:question_alternatives)
  end

  def training_question_query(training) do
    from q in Question,
      join: tq in TrainingQuestion,
      on: tq.training_id == ^training.id and q.id == tq.question_id,
      left_join: r in Response,
      on: r.training_id == ^training.id and r.question_id == q.id,
      order_by: [asc: tq.position, asc: q.created_at],
      select: %Question{
        q
        | position: fragment("ROW_NUMBER () OVER ( ORDER BY ?, ? )", tq.position, q.created_at),
          response: r
      }
  end

  def exam_session_question_query(exam_session) do
    from q in Question,
      join: eq in ExamQuestion,
      on: eq.exam_id == ^exam_session.exam_id and q.id == eq.question_id,
      left_join: r in Response,
      on: r.exam_session_id == ^exam_session.id and r.question_id == q.id,
      order_by: [asc: eq.position, asc: q.created_at],
      select: %Question{
        q
        | position: fragment("ROW_NUMBER () OVER ( ORDER BY ?, ? )", eq.position, q.created_at),
          response: r
      }
  end

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{source: %Question{}}

  """
  def change_question(%Question{} = question) do
    Question.changeset(question, %{})
  end

  alias Edukator.Questions.QuestionAlternative

  @doc """
  Returns the list of question_alternatives.

  ## Examples

      iex> list_question_alternatives()
      [%QuestionAlternative{}, ...]

  """
  def list_question_alternatives do
    Repo.all(QuestionAlternative)
  end

  @doc """
  Gets a single question_alternative.

  Raises `Ecto.NoResultsError` if the QuestionAlternative does not exist.

  ## Examples

      iex> get_question_alternative!(123)
      %QuestionAlternative{}

      iex> get_question_alternative!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question_alternative!(id), do: Repo.get!(QuestionAlternative, id)

  @doc """
  Creates a question_alternative.

  ## Examples

      iex> create_question_alternative(%{field: value})
      {:ok, %QuestionAlternative{}}

      iex> create_question_alternative(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question_alternative(attrs \\ %{}) do
    %QuestionAlternative{}
    |> QuestionAlternative.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question_alternative.

  ## Examples

      iex> update_question_alternative(question_alternative, %{field: new_value})
      {:ok, %QuestionAlternative{}}

      iex> update_question_alternative(question_alternative, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question_alternative(%QuestionAlternative{} = question_alternative, attrs) do
    question_alternative
    |> QuestionAlternative.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a QuestionAlternative.

  ## Examples

      iex> delete_question_alternative(question_alternative)
      {:ok, %QuestionAlternative{}}

      iex> delete_question_alternative(question_alternative)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question_alternative(%QuestionAlternative{} = question_alternative) do
    Repo.delete(question_alternative)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question_alternative changes.

  ## Examples

      iex> change_question_alternative(question_alternative)
      %Ecto.Changeset{source: %QuestionAlternative{}}

  """
  def change_question_alternative(%QuestionAlternative{} = question_alternative) do
    QuestionAlternative.changeset(question_alternative, %{})
  end

  alias Edukator.Questions.QuestionSource

  @doc """
  Returns the list of question_sources.

  ## Examples

      iex> list_question_sources()
      [%QuestionSource{}, ...]

  """
  def list_question_sources do
    Repo.all(QuestionSource)
  end

  @doc """
  Gets a single source.

  Raises `Ecto.NoResultsError` if the QuestionSource does not exist.

  ## Examples

      iex> get_source!(123)
      %QuestionSource{}

      iex> get_source!(456)
      ** (Ecto.NoResultsError)

  """
  def get_source!(id), do: Repo.get!(QuestionSource, id)

  @doc """
  Creates a source.

  ## Examples

      iex> create_source(%{field: value})
      {:ok, %QuestionSource{}}

      iex> create_source(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_source(attrs \\ %{}) do
    %QuestionSource{}
    |> QuestionSource.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a source.

  ## Examples

      iex> update_source(source, %{field: new_value})
      {:ok, %QuestionSource{}}

      iex> update_source(source, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_source(%QuestionSource{} = source, attrs) do
    source
    |> QuestionSource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a QuestionSource.

  ## Examples

      iex> delete_source(source)
      {:ok, %QuestionSource{}}

      iex> delete_source(source)
      {:error, %Ecto.Changeset{}}

  """
  def delete_source(%QuestionSource{} = source) do
    Repo.delete(source)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking source changes.

  ## Examples

      iex> change_source(source)
      %Ecto.Changeset{source: %QuestionSource{}}

  """
  def change_source(%QuestionSource{} = source) do
    QuestionSource.changeset(source, %{})
  end

  alias Edukator.Questions.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{source: %Tag{}}

  """
  def change_tag(%Tag{} = tag) do
    Tag.changeset(tag, %{})
  end
end
