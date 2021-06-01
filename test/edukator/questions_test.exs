defmodule Edukator.QuestionsTest do
  use Edukator.DataCase
  import Edukator.Factory

  alias Edukator.Questions

  describe "comments and teachers" do
    test "get_comment!/2" do
      comment = insert(:comment)
      %{question: question_with_comment} = comment

      question_without_comment = insert(:question)

      comment = Questions.get_comment!(question_with_comment, "public")

      assert %Edukator.Questions.Comment{} = comment

      nothing = Questions.get_comment!(question_without_comment, "public")

      assert is_nil(nothing)
    end

    test "get_teacher!/2" do
      comment = insert(:comment)

      teacher = Questions.get_teacher!(comment, "public")

      assert %Edukator.Questions.Teacher{} = teacher

      assert teacher.id == comment.teacher_id
    end
  end

  #
  # describe "questions" do
  #   alias Edukator.Questions.Question
  #
  #   @valid_attrs %{
  #     broken: true,
  #     cancelled: true,
  #     content: "some content",
  #     outdated: true,
  #     difficulty: 120.5
  #   }
  #   @update_attrs %{
  #     broken: false,
  #     cancelled: false,
  #     content: "some updated content",
  #     outdated: false,
  #     difficulty: 456.7
  #   }
  #   @invalid_attrs %{broken: nil, cancelled: nil, content: nil, outdated: nil, difficulty: nil}
  #
  #   def question_fixture(attrs \\ %{}) do
  #     {:ok, question} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Questions.create_question()
  #
  #     question
  #   end
  #
  #   test "list_questions/0 returns all questions" do
  #     question = question_fixture()
  #     assert Questions.list_questions() == [question]
  #   end
  #
  #   test "get_question!/1 returns the question with given id" do
  #     question = question_fixture()
  #     assert Questions.get_question!(question.id) == question
  #   end
  #
  #   test "create_question/1 with valid data creates a question" do
  #     assert {:ok, %Question{} = question} = Questions.create_question(@valid_attrs)
  #     assert question.broken == true
  #     assert question.cancelled == true
  #     assert question.content == "some content"
  #     assert question.outdated == true
  #     assert question.difficulty == 120.5
  #   end
  #
  #   test "create_question/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Questions.create_question(@invalid_attrs)
  #   end
  #
  #   test "update_question/2 with valid data updates the question" do
  #     question = question_fixture()
  #     assert {:ok, %Question{} = question} = Questions.update_question(question, @update_attrs)
  #     assert question.broken == false
  #     assert question.cancelled == false
  #     assert question.content == "some updated content"
  #     assert question.outdated == false
  #     assert question.difficulty == 456.7
  #   end
  #
  #   test "update_question/2 with invalid data returns error changeset" do
  #     question = question_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Questions.update_question(question, @invalid_attrs)
  #     assert question == Questions.get_question!(question.id)
  #   end
  #
  #   test "delete_question/1 deletes the question" do
  #     question = question_fixture()
  #     assert {:ok, %Question{}} = Questions.delete_question(question)
  #     assert_raise Ecto.NoResultsError, fn -> Questions.get_question!(question.id) end
  #   end
  #
  #   test "change_question/1 returns a question changeset" do
  #     question = question_fixture()
  #     assert %Ecto.Changeset{} = Questions.change_question(question)
  #   end
  # end
  #
  # describe "question_alternatives" do
  #   alias Edukator.Questions.QuestionAlternative
  #
  #   @valid_attrs %{content: "some content", correct: true, counter: 42, letter: "some letter"}
  #   @update_attrs %{
  #     content: "some updated content",
  #     correct: false,
  #     counter: 43,
  #     letter: "some updated letter"
  #   }
  #   @invalid_attrs %{content: nil, correct: nil, counter: nil, letter: nil}
  #
  #   def question_alternative_fixture(attrs \\ %{}) do
  #     {:ok, question_alternative} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Questions.create_question_alternative()
  #
  #     question_alternative
  #   end
  #
  #   test "list_question_question_alternatives/0 returns all question_question_alternatives" do
  #     question_alternative = question_alternative_fixture()
  #     assert Questions.list_question_question_alternatives() == [question_alternative]
  #   end
  #
  #   test "get_question_alternative!/1 returns the question_alternative with given id" do
  #     question_alternative = question_alternative_fixture()
  #     assert Questions.get_question_alternative!(question_alternative.id) == question_alternative
  #   end
  #
  #   test "create_question_alternative/1 with valid data creates a question_alternative" do
  #     assert {:ok, %QuestionAlternative{} = question_alternative} =
  #              Questions.create_question_alternative(@valid_attrs)
  #
  #     assert question_alternative.content == "some content"
  #     assert question_alternative.correct == true
  #     assert question_alternative.counter == 42
  #     assert question_alternative.letter == "some letter"
  #   end
  #
  #   test "create_question_alternative/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Questions.create_question_alternative(@invalid_attrs)
  #   end
  #
  #   test "update_question_alternative/2 with valid data updates the question_alternative" do
  #     question_alternative = question_alternative_fixture()
  #
  #     assert {:ok, %QuestionAlternative{} = question_alternative} =
  #              Questions.update_question_alternative(question_alternative, @update_attrs)
  #
  #     assert question_alternative.content == "some updated content"
  #     assert question_alternative.correct == false
  #     assert question_alternative.counter == 43
  #     assert question_alternative.letter == "some updated letter"
  #   end
  #
  #   test "update_question_alternative/2 with invalid data returns error changeset" do
  #     question_alternative = question_alternative_fixture()
  #
  #     assert {:error, %Ecto.Changeset{}} =
  #              Questions.update_question_alternative(question_alternative, @invalid_attrs)
  #
  #     assert question_alternative == Questions.get_question_alternative!(question_alternative.id)
  #   end
  #
  #   test "delete_question_alternative/1 deletes the question_alternative" do
  #     question_alternative = question_alternative_fixture()
  #
  #     assert {:ok, %QuestionAlternative{}} =
  #              Questions.delete_question_alternative(question_alternative)
  #
  #     assert_raise Ecto.NoResultsError, fn ->
  #       Questions.get_question_alternative!(question_alternative.id)
  #     end
  #   end
  #
  #   test "change_question_alternative/1 returns a question_alternative changeset" do
  #     question_alternative = question_alternative_fixture()
  #     assert %Ecto.Changeset{} = Questions.change_question_alternative(question_alternative)
  #   end
  # end
  #
  # describe "question_sources" do
  #   alias Edukator.Questions.Source
  #
  #   @valid_attrs %{source_id: "some source_id", source_name: "some source_name"}
  #   @update_attrs %{source_id: "some updated source_id", source_name: "some updated source_name"}
  #   @invalid_attrs %{source_id: nil, source_name: nil}
  #
  #   def source_fixture(attrs \\ %{}) do
  #     {:ok, source} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Questions.create_source()
  #
  #     source
  #   end
  #
  #   test "list_question_sources/0 returns all question_sources" do
  #     source = source_fixture()
  #     assert Questions.list_question_sources() == [source]
  #   end
  #
  #   test "get_source!/1 returns the source with given id" do
  #     source = source_fixture()
  #     assert Questions.get_source!(source.id) == source
  #   end
  #
  #   test "create_source/1 with valid data creates a source" do
  #     assert {:ok, %Source{} = source} = Questions.create_source(@valid_attrs)
  #     assert source.source_id == "some source_id"
  #     assert source.source_name == "some source_name"
  #   end
  #
  #   test "create_source/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Questions.create_source(@invalid_attrs)
  #   end
  #
  #   test "update_source/2 with valid data updates the source" do
  #     source = source_fixture()
  #     assert {:ok, %Source{} = source} = Questions.update_source(source, @update_attrs)
  #     assert source.source_id == "some updated source_id"
  #     assert source.source_name == "some updated source_name"
  #   end
  #
  #   test "update_source/2 with invalid data returns error changeset" do
  #     source = source_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Questions.update_source(source, @invalid_attrs)
  #     assert source == Questions.get_source!(source.id)
  #   end
  #
  #   test "delete_source/1 deletes the source" do
  #     source = source_fixture()
  #     assert {:ok, %Source{}} = Questions.delete_source(source)
  #     assert_raise Ecto.NoResultsError, fn -> Questions.get_source!(source.id) end
  #   end
  #
  #   test "change_source/1 returns a source changeset" do
  #     source = source_fixture()
  #     assert %Ecto.Changeset{} = Questions.change_source(source)
  #   end
  # end
  #
  # describe "tags" do
  #   alias Edukator.Questions.Tag
  #
  #   @valid_attrs %{kind: "some kind", name: "some name", slug: "some slug"}
  #   @update_attrs %{
  #     kind: "some updated kind",
  #     name: "some updated name",
  #     slug: "some updated slug"
  #   }
  #   @invalid_attrs %{kind: nil, name: nil, slug: nil}
  #
  #   def tag_fixture(attrs \\ %{}) do
  #     {:ok, tag} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Questions.create_tag()
  #
  #     tag
  #   end
  #
  #   test "list_tags/0 returns all tags" do
  #     tag = tag_fixture()
  #     assert Questions.list_tags() == [tag]
  #   end
  #
  #   test "get_tag!/1 returns the tag with given id" do
  #     tag = tag_fixture()
  #     assert Questions.get_tag!(tag.id) == tag
  #   end
  #
  #   test "create_tag/1 with valid data creates a tag" do
  #     assert {:ok, %Tag{} = tag} = Questions.create_tag(@valid_attrs)
  #     assert tag.kind == "some kind"
  #     assert tag.name == "some name"
  #     assert tag.slug == "some slug"
  #   end
  #
  #   test "create_tag/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Questions.create_tag(@invalid_attrs)
  #   end
  #
  #   test "update_tag/2 with valid data updates the tag" do
  #     tag = tag_fixture()
  #     assert {:ok, %Tag{} = tag} = Questions.update_tag(tag, @update_attrs)
  #     assert tag.kind == "some updated kind"
  #     assert tag.name == "some updated name"
  #     assert tag.slug == "some updated slug"
  #   end
  #
  #   test "update_tag/2 with invalid data returns error changeset" do
  #     tag = tag_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Questions.update_tag(tag, @invalid_attrs)
  #     assert tag == Questions.get_tag!(tag.id)
  #   end
  #
  #   test "delete_tag/1 deletes the tag" do
  #     tag = tag_fixture()
  #     assert {:ok, %Tag{}} = Questions.delete_tag(tag)
  #     assert_raise Ecto.NoResultsError, fn -> Questions.get_tag!(tag.id) end
  #   end
  #
  #   test "change_tag/1 returns a tag changeset" do
  #     tag = tag_fixture()
  #     assert %Ecto.Changeset{} = Questions.change_tag(tag)
  #   end
  # end
end
