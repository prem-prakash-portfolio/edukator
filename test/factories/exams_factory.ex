defmodule Edukator.ExamsFactory do
  @moduledoc """
  Factory for modules inside the `Exams` context
  """

  alias Edukator.Repo

  defmacro __using__(_opts) do
    quote do
      def exam_factory do
        %Edukator.Exams.Exam{
          name: sequence(:exam_name, &"Exam #{&1}"),
          year: 2019,
          author: build(:author),
          job: build(:job),
          organization: build(:organization)
        }
      end

      def with_questions(%Edukator.Exams.Exam{} = exam, quantity \\ 5) do
        quantity
        |> insert_list(:question)
        |> Enum.each(&insert(:exam_question, question: &1, exam: exam))

        Repo.preload(exam, :questions)
      end

      def exam_question_factory do
        %Edukator.Exams.ExamQuestion{
          question: build(:question),
          exam: build(:exam)
        }
      end

      def author_factory do
        %Edukator.Exams.Author{
          name: sequence(:author_name, &"Author Surname #{&1}"),
          slug: sequence(:author_slug, &"author#{&1}")
        }
      end

      def organization_factory do
        %Edukator.Exams.Organization{
          name: sequence(:organization_name, &"Organization #{&1}"),
          slug: sequence(:organization_slug, &"organization#{&1}")
        }
      end

      def job_factory do
        %Edukator.Exams.Job{
          name: sequence(:job_name, &"Job #{&1}"),
          slug: sequence(:job_slug, &"job#{&1}")
        }
      end
    end
  end
end
