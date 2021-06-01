defmodule Edukator.Trainings.Adaptive do
  @moduledoc """
  Calculate proficiency and get next question
  """

  import Ecto.Query

  alias Edukator.Repo
  alias Edukator.Responses.Response
  alias Edukator.Trainings.TrainingQuestion
  alias Edukator.QuestionFilter
  alias Edukator.QuestionFilterQuery

  def maybe_insert_next_question(training, tenant \\ "public") do
    training = training |> Repo.preload(:training_questions)

    total_questions = length(training.training_questions)

    if total_questions == training.questions_count do
      training
    else
      next_question = get_next_question(training, tenant)

      insert_training_question(
        training.id,
        next_question.id,
        total_questions + 1,
        tenant
      )

      training |> Repo.preload(:training_questions, force: true)
    end
  end

  defp get_next_question(training, tenant) do
    filter_query =
      training.filter
      |> QuestionFilter.process_filters()
      |> QuestionFilterQuery.build_query(training.user_id)
      |> exclude(:distinct)

    current_training_questions_ids =
      from(tq in TrainingQuestion,
        where: tq.training_id == ^training.id,
        select: tq.question_id
      )
      |> Repo.all()

    proficiency = calculate_proficiency(training, tenant)

    query =
      from q in filter_query,
        where: q.id not in ^current_training_questions_ids,
        order_by: fragment("abs(difficulty - ?)", ^proficiency),
        limit: 1

    Repo.one(query, prefix: tenant)
  end

  defp calculate_proficiency(training, tenant) do
    training
    |> get_responses(tenant)
    |> calculate_next_item_proficiency()
    |> normalize_proficiency()
  end

  #
  # Transform from [-infinity, +infinity] to [0, 1] range
  #
  defp normalize_proficiency(proficiency) do
    e = :math.exp(proficiency)
    e / (1.0 + e)
  end

  defp get_responses(training, tenant) do
    query =
      from r in Response,
        join: t in assoc(r, :training),
        where: t.id == ^training.id,
        join: qa in assoc(r, :question_alternative),
        select: qa.correct

    Repo.all(query, prefix: tenant)
  end

  # https://www.rasch.org/rmt/rmt22g.htm
  #
  # Practical Adaptive Testing CAT Algorithm
  # Here are the core steps needed for practical adaptive testing with the Rasch model.
  #
  # 0. Request next candidate: Set D=0, L=0, H=0, and R=0.
  # 1. Find next item near difficulty (D).
  # 2. Set D at the actual calibration of that item.
  # 3. Administer that item.
  # 4. Obtain a response.
  # 5. Score that response.
  # 6. Count the items taken: L = L + 1
  # 7. Add the difficulties used: H = H + D
  #
  # If response not correct,
  # 8. Target next item difficulty: D = D - 2/L
  #
  # If response correct,
  # 9. Count right answers: R = R + 1
  # 10. Target next item difficulty: D = D + 2/L
  #
  # If not ready to decide to pass/fail,
  # 11. Go to step 1.
  #
  # If ready to decide pass/fail,
  # 12. Calculate wrong answers: W = L - R
  # 13. Estimate measure: B = H/L + loge(R/W)
  # If W = 0 then B = H/L + loge(R-0.5 / W+0.5)
  # If R = 0 then B = H/L + loge(R+0.5 / W-0.5)
  # For a more precise estimate of B, see Estimating Measures with Known Item Difficulties
  # 14. Estimate Error: S = sqrt[L/(R*W)]
  # If W = 0 then S = sqrt[L/(R-0.5 * W+0.5)]
  # If R = 0 then S = sqrt[L/(R+0.5 * W-0.5)]
  #
  # 15. Compare measure B with pass/fail standard T.
  # 16. If (T - S) < B < (T + S), go to step 1.
  # 17. If (B - S) > T, then pass.
  # 18. If (B + S) < T, then fail.
  # 20. Go to step 0.
  #
  defp calculate_next_item_proficiency(responses) do
    #
    # right_answers is commented because it is not being used
    #
    {_items_taken, next_item_proficiency} =
      Enum.reduce(responses, {0, 0}, fn correct_response, {items_taken, next_item_proficiency} ->
        items_taken = items_taken + 1

        next_item_proficiency =
          if correct_response,
            do: next_item_proficiency + 2 / items_taken,
            else: next_item_proficiency - 2 / items_taken

        # right_answers = if correct_response, do: right_answers + 1, else: right_answers

        {
          items_taken,
          next_item_proficiency
        }
      end)

    next_item_proficiency
  end

  defp insert_training_question(training_id, question_id, position, tenant) do
    %TrainingQuestion{}
    |> TrainingQuestion.create_changeset(%{
      training_id: training_id,
      question_id: question_id,
      position: position
    })
    |> Repo.insert!(prefix: tenant)
  end
end
