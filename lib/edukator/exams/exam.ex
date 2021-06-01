defmodule Edukator.Exams.Exam do
  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset
  alias Edukator.ExamSessions.ExamSession
  alias Edukator.Exams.{Author, ExamQuestion, Job, Organization}
  alias Edukator.Questions.Question

  defmodule SessionsData do
    @moduledoc """
    Field that stores data related to this exam's sessions
    """
    @derive {Jason.Encoder, except: [:__meta__]}
    use Edukator.Schema
    import Ecto.Changeset
    @primary_key false

    embedded_schema do
      field(:mean_percentage_correct, :float)
      field(:finished_sessions_count, :integer)
    end

    def changeset(sessions_data, attrs) do
      sessions_data
      |> cast(attrs, [:mean_percentage_correct, :finished_sessions_count])
    end
  end

  schema "exams" do
    field :name, :string
    field :area, :string
    field :edition, :string
    field :exam_questions_count, :integer
    field :speciality, :string
    field :year, :integer
    field :educational_level, :string
    embeds_one(:sessions_data, SessionsData, on_replace: :update)
    belongs_to(:author, Author)
    belongs_to(:job, Job)
    belongs_to(:organization, Organization)
    has_many(:exam_sessions, ExamSession)
    has_many(:exam_questions, ExamQuestion)

    many_to_many(:questions, Question, join_through: "exam_questions")

    # has_many(:questions, through: ExamQuestion)

    timestamps()
  end

  @doc false
  def changeset(exam, attrs) do
    exam
    |> cast(attrs, [:area, :edition, :exam_questions_count, :name, :speciality, :year])
    |> cast_embed(:sessions_data)
    |> cast_assoc(:author, required: true)
    |> cast_assoc(:job)
    |> cast_assoc(:organization, required: true)
    |> validate_required([:exam_questions_count, :name, :year])
  end
end
