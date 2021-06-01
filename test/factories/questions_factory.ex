defmodule Edukator.QuestionsFactory do
  @moduledoc """
  Factory for modules inside the `Questions` context
  """

  alias Edukator.Repo

  defmacro __using__(_opts) do
    quote do
      def question_factory do
        %Edukator.Questions.Question{
          content: "Question 1 content"
        }
      end

      def with_alternatives(%Edukator.Questions.Question{} = question) do
        insert_list(4, :question_alternative, question: question, correct: false)
        insert(:question_alternative, question: question, correct: true)
        Repo.preload(question, :question_alternatives)
      end

      def question_alternative_factory do
        %Edukator.Questions.QuestionAlternative{
          content: "Alt 1",
          question: build(:question),
          letter: sequence("A")
        }
      end

      def question_tag_factory do
        %Edukator.Questions.QuestionTag{
          question: build(:question),
          tag: build(:tag)
        }
      end

      def question_source_factory do
        %Edukator.Questions.QuestionSource{}
      end

      def comment_factory do
        %Edukator.Questions.Comment{
          content: "blablablabla",
          question: build(:question),
          teacher: build(:teacher)
        }
      end

      def teacher_factory do
        %Edukator.Questions.Teacher{
          name: "Fulano da silva",
          email: "dasilva@gmail.com"
        }
      end

      def tag_factory do
        %Edukator.Questions.Tag{
          name: "Tag 1",
          slug: "tag1",
          kind: Enum.random(["Subject", "Discipline", "Video"])
        }
      end

      def discipline_tag_factory do
        %Edukator.Questions.Tag{
          name: "Tag 1",
          slug: "tag1",
          kind: "Discipline"
        }
      end

      def subject_tag_factory do
        %Edukator.Questions.Tag{
          name: "Tag 1",
          slug: "tag1",
          kind: "Subject"
        }
      end

      def video_tag_factory do
        %Edukator.Questions.Tag{
          name: "Tag 1",
          slug: "tag1",
          kind: "Video"
        }
      end
    end
  end
end
