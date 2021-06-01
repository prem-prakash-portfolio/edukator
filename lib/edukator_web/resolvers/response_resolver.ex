defmodule EdukatorWeb.Resolvers.ResponseResolver do
  @moduledoc false
  alias Edukator.Repo

  alias Edukator.ExamSessions
  alias Edukator.Responses
  alias Edukator.Trainings
  alias Edukator.Trainings.Adaptive
  alias Edukator.Accounts
  alias Edukator.Exams

  def answer_question(_parent, %{id: id, type: "ExamSession"} = args, %{
        context: %{current_user: user, tenant: tenant}
      }) do
    response =
      args
      |> Responses.answer_question(tenant)
      |> Repo.preload(:question_alternative)

    exam_session =
      ExamSessions.get_exam_session(id, user.id, tenant)
      |> Repo.preload(:exam)

    if response.question_alternative.correct do
      ExamSessions.update_correct_questions_count(exam_session)
    end

    if exam_session.responses_count == exam_session.exam.exam_questions_count do
        Exams.update_sessions_data(exam_session, tenant)
    end

    show_trial_invitation =
      user
      |> Accounts.update_answered_questions_for_popup(tenant)
      |> Accounts.show_trial_invitation?()

    {:ok,
     %{
       exam_session: exam_session,
       question: %{id: response.question_id, response: response},
       show_trial_invitation: show_trial_invitation
     }}
  end

  def answer_question(_parent, %{id: id, type: "Training"} = args, %{
        context: %{current_user: user, tenant: tenant}
      }) do
    Repo.transaction(fn ->
      response =
        args
        |> Responses.answer_question(tenant)
        |> Repo.preload(:question_alternative)

      training =
        id
        |> Trainings.get_training!(user.id, tenant)
        |> Adaptive.maybe_insert_next_question(tenant)

      show_trial_invitation =
        user
        |> Accounts.update_answered_questions_for_popup(tenant)
        |> Accounts.show_trial_invitation?()

      %{
        training: training,
        question: %{id: response.question_id, response: response},
        show_trial_invitation: show_trial_invitation
      }
    end)
  end

  def answer_question(_parent, _args, _context),
    do: {:error, %{key: "auth", messages: "Unauthenticated"}}
end
