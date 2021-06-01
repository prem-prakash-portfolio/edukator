defmodule Edukator.QuestionFilterTest do
  use Edukator.DataCase
  import Edukator.Factory
  alias Edukator.QuestionFilter
  alias Edukator.Exams.Organization
  alias Edukator.Questions.Question
  alias Edukator.Repo

  describe "filter/3" do
    test "always get all organizations" do
      insert_list(5, :exam)
      user = insert(:user)
      organizations_count = Repo.aggregate(Organization, :count, :id)
      assert organizations_count >= 5
      result = QuestionFilter.filter(%{filters: %{}}, user, "public")
      assert organizations_count == Enum.count(result.organizations)
    end

    test "get years scoped by organizations" do
    end

    test "get authors scoped by organizations" do
    end

    test "get disciplines scoped by previous filters" do
    end

    test "get subjects scoped by previous filters" do
    end

    test "get unfiltered total questions count" do
      insert_list(5, :question)
      user = insert(:user)
      questions_count = Repo.aggregate(Question, :count, :id)
      assert questions_count >= 5
      result = QuestionFilter.filter(%{filters: %{}}, user, "public")
      assert questions_count == result.total_questions
    end

    test "get filtered total questions count" do
    end

    test "should filter educational level" do
      insert_list(3, :exam, educational_level: "Superior")
      |> Enum.each(&with_questions(&1))

      insert_list(2, :exam, educational_level: "Médio")
      |> Enum.each(&with_questions(&1))

      insert_list(1, :exam, educational_level: "Fundamental")
      |> Enum.each(&with_questions(&1))

      insert_list(5, :exam)
      |> Enum.each(&with_questions(&1))

      user = insert(:user)

      resultSuperior =
        QuestionFilter.filter(%{filters: %{educational_levels: ["Superior"]}}, user, "public")

      assert resultSuperior.total_questions == 15

      resultMedio =
        QuestionFilter.filter(%{filters: %{educational_levels: ["Médio"]}}, user, "public")

      assert resultMedio.total_questions == 10

      resultFundamental =
        QuestionFilter.filter(%{filters: %{educational_levels: ["Fundamental"]}}, user, "public")

      assert resultFundamental.total_questions == 5
    end
  end
end
