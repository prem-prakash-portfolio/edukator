defmodule Edukator.QuestionFilterQueryQueryTest do
  use Edukator.DataCase
  import Edukator.Factory
  alias Edukator.QuestionFilterQuery
  alias Edukator.Repo

  describe "build_query/1" do
    test "filter cancelled questions" do
      insert_list(2, :question)
      insert_list(1, :question, cancelled: true)

      query = QuestionFilterQuery.build_query(%{}, 1)
      assert Repo.aggregate(query, :count, :id) == 2
    end

    test "filter outdated questions" do
      insert_list(2, :question)
      insert_list(1, :question, outdated: true)

      query = QuestionFilterQuery.build_query(%{}, 1)
      assert Repo.aggregate(query, :count, :id) == 2
    end

    test "filter answered, unanswered, correct or wrong" do
      %{user_id: user_id} = training = insert(:training)

      questions_without_answers = Enum.random(1..5)
      questions_with_correct_answers = Enum.random(1..5)
      questions_with_wrong_answers = Enum.random(1..5)

      questions_without_answers |> insert_list(:question)

      questions_with_correct_answers
      |> insert_list(:question)
      |> Enum.map(&with_alternatives(&1))
      |> Enum.each(fn question ->
        correct_alternative = Enum.find(question.question_alternatives, &(&1.correct == true))

        insert(:response,
          question: question,
          question_alternative: correct_alternative,
          training: training
        )
      end)

      questions_with_wrong_answers
      |> insert_list(:question)
      |> Enum.map(&with_alternatives(&1))
      |> Enum.each(fn question ->
        correct_alternative = Enum.find(question.question_alternatives, &(&1.correct == false))

        insert(:response,
          question: question,
          question_alternative: correct_alternative,
          training: training
        )
      end)

      query =
        QuestionFilterQuery.build_query(
          %{answered_questions: "answered", correct_questions: "correct"},
          user_id
        )

      assert Repo.aggregate(query, :count, :id) == questions_with_correct_answers

      query =
        QuestionFilterQuery.build_query(
          %{answered_questions: "answered", correct_questions: "wrong"},
          user_id
        )

      assert Repo.aggregate(query, :count, :id) == questions_with_wrong_answers

      query =
        QuestionFilterQuery.build_query(
          %{answered_questions: "answered", correct_questions: "all"},
          user_id
        )

      assert Repo.aggregate(query, :count, :id) ==
               questions_with_correct_answers + questions_with_wrong_answers

      query = QuestionFilterQuery.build_query(%{answered_questions: "answered"}, user_id)

      assert Repo.aggregate(query, :count, :id) ==
               questions_with_correct_answers + questions_with_wrong_answers

      query =
        QuestionFilterQuery.build_query(
          %{answered_questions: "unanswered"},
          user_id
        )

      assert Repo.aggregate(query, :count, :id) == questions_without_answers

      query = QuestionFilterQuery.build_query(%{}, user_id)

      assert Repo.aggregate(query, :count, :id) ==
               questions_without_answers + questions_with_correct_answers +
                 questions_with_wrong_answers
    end
  end
end
