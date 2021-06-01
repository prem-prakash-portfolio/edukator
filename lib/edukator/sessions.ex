defmodule Edukator.Sessions do
  @moduledoc """
  The Exams context.
  """

  import Ecto.Query, warn: false
  alias Edukator.Exams.Exam
  alias Edukator.ExamSessions.ExamSession
  alias Edukator.Repo
  alias Edukator.Trainings.Training

  def get_session(args, tenant \\ "public")

  def get_session(%{id: id, type: type} = args, tenant) do
    case type do
      "ExamSession" ->
        args = args |> Map.drop([:id, :type]) |> Map.put(:exam_session_id, id)
        %{exam_session: get_session(args, tenant)}

      "Training" ->
        args = args |> Map.drop([:id, :type]) |> Map.put(:training_id, id)
        %{training: get_session(args, tenant)}

      _ ->
        nil
    end
  end

  def get_session(%{exam_session_id: exam_session_id, user_id: user_id}, tenant) do
    query = from e in ExamSession, where: e.id == ^exam_session_id and e.user_id == ^user_id
    Repo.one!(query, prefix: tenant)
  end

  def get_session(%{training_id: training_id, user_id: user_id}, tenant) do
    query = from t in Training, where: t.id == ^training_id and t.user_id == ^user_id
    Repo.one!(query, prefix: tenant)
  end

  def list(%{search_text: search_text, size: size}, user, tenant \\ "public") do
    trainings =
      user
      |> trainings_query(size, search_text)
      |> Repo.all(prefix: tenant)

    exams =
      user
      |> exams_query(size, search_text)
      |> Repo.all(prefix: tenant)

    query = from es in ExamSession, where: es.user_id == ^user.id

    exams =
      exams
      |> Repo.preload(exam_sessions: query)
      |> Enum.uniq()

    %{
      trainings: trainings,
      exams: exams
    }
  end

  defp exams_query(user, limit, search_text) do
    query =
      from e in Exam,
        join: es in assoc(e, :exam_sessions),
        on: es.user_id == ^user.id,
        left_join: a in assoc(e, :author),
        left_join: j in assoc(e, :job),
        left_join: o in assoc(e, :organization),
        order_by: [desc: es.updated_at],
        preload: [:author, :job, :organization],
        limit: ^limit

    if is_binary(search_text) and byte_size(search_text) > 0 do
      ilike = "%#{search_text}%"
      from(e in query, where: ilike(e.name, ^ilike))
    else
      query
    end
  end

  defp trainings_query(user, limit, search_text) do
    query =
      from t in Training,
        where: t.user_id == ^user.id,
        limit: ^limit,
        order_by: [desc: t.updated_at]

    if is_binary(search_text) and byte_size(search_text) > 0 do
      ilike = "%#{search_text}%"
      from(t in query, where: ilike(t.name, ^ilike))
    else
      query
    end
  end
end
