defmodule Edukator.Trainings.Training do
  defmodule Algorithm do
    @moduledoc false
    use Exnumerator, values: ["RANDOM", "ADAPTIVE"]
  end

  defmodule Filter do
    @moduledoc false
    use Edukator.Schema
    import Ecto.Changeset

    embedded_schema do
      field(:authors, {:array, :integer})
      field(:disciplines, {:array, :integer})
      field(:organizations, {:array, :integer})
      field(:subjects, {:array, :integer})
      field(:years, {:array, :integer})
      field(:educational_levels, {:array, :string})
      field(:answered_questions, :string)
      field(:correct_questions, :string)
    end

    @doc false
    def changeset(filter, attrs) do
      filter
      |> cast(attrs, [
        :authors,
        :disciplines,
        :organizations,
        :subjects,
        :years,
        :educational_levels,
        :answered_questions,
        :correct_questions
      ])
    end
  end

  @moduledoc false
  use Edukator.Schema
  import Ecto.Changeset

  alias Edukator.Accounts.User
  alias Edukator.Questions.Question
  alias Edukator.Responses.Response
  alias Edukator.Trainings.TrainingQuestion

  schema "trainings" do
    field :name, :string
    field :questions_count, :integer
    field :responses_count, :integer, default: 0
    belongs_to(:user, User)

    field :algorithm, Algorithm

    embeds_one :filter, Filter

    many_to_many(:questions, Question,
      join_through: "training_questions",
      join_keys: [training_id: :id, question_id: :id]
    )

    # ideal fazer por migration
    has_many(:responses, Response, on_delete: :delete_all)
    # ideal fazer por migration
    has_many(:training_questions, TrainingQuestion, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(training, attrs) do
    training
    |> cast(attrs, [:name, :questions_count])
    |> validate_required([:name, :questions_count])
  end

  @doc false
  def create_changeset(training, attrs) do
    training
    |> cast(attrs, [:user_id, :name, :questions_count])
    |> cast_embed(:filter)
    |> cast_assoc(:training_questions, required: true)
    |> validate_required([:user_id, :name, :filter, :questions_count])
  end
end
