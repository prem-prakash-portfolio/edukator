defmodule Edukator.Accounts.User do
  @moduledoc false
  @derive {Jason.Encoder, except: [:__meta__, :exam_sessions, :trainings]}

  alias __MODULE__
  use Edukator.Schema
  import Ecto.Changeset
  import Edukator.ValidationHelpers
  import Edukator.Sanitization

  alias Bcrypt

  defmodule AccountType do
    @moduledoc false
    use Exnumerator, values: ["FULL", "TRIAL"]
  end

  defmodule Goals do
    @moduledoc false

    @derive {Jason.Encoder, except: [:__meta__]}
    use Edukator.Schema
    import Ecto.Changeset
    @primary_key false

    embedded_schema do
      field(:organizations, {:array, :integer})
      field(:jobs, {:array, :integer})
    end

    @doc false
    def changeset(filter, attrs) do
      filter
      |> cast(attrs, [:organizations, :jobs])
    end
  end

  defmodule ViewedTours do
    @moduledoc """
    This field indicates if the user has already went through each of the available tours in the product.
    If false, then the user will go through the tour and once it's over, the field will be set to true.
    """
    @derive {Jason.Encoder, except: [:__meta__]}
    use Edukator.Schema
    import Ecto.Changeset
    @primary_key false

    embedded_schema do
      field(:menu, :boolean)
      field(:search, :boolean)
      field(:new_training, :boolean)
    end

    def changeset(tours, attrs) do
      tours
      |> cast(attrs, [:menu, :search, :new_training])
    end
  end

  alias Edukator.Notifications.NotificationSetting

  schema "users" do
    field(:email, :string)
    field(:encrypted_password, :string)
    field(:current_password, :string, virtual: true)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:reset_password_token, :string)
    field(:reset_password_sent_at, :utc_datetime)
    field(:name, :string)
    field(:phone, :string)
    field(:auth_token, :string)
    field(:token, :string, virtual: true)
    field(:account_type, AccountType)
    field(:trial_expiration_date, :date)
    field(:answered_questions_for_popup, :integer)
    field(:last_sign_in_at, :utc_datetime)
    embeds_many(:notification_settings, NotificationSetting, on_replace: :delete)
    embeds_one(:goals, Goals, on_replace: :update)
    embeds_one(:viewed_tours, ViewedTours, on_replace: :update)
    has_many(:exam_sessions, Edukator.ExamSessions.ExamSession)
    has_many(:trainings, Edukator.Trainings.Training)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end

  @doc false
  def update_user_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :account_type, :answered_questions_for_popup])
    |> cast_embed(:goals)
    |> cast_embed(:viewed_tours)
    |> validate_required([:email, :name])
    # |> validate_document(:document)
    |> squish(:email)
    |> downcase(:email)
    |> validate_email(:email)
    |> update_password_if_present()
  end

  @doc false
  def create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :account_type, :trial_expiration_date])
    |> validate_required([:name, :email, :password, :account_type])
    |> squish(:email)
    |> downcase(:email)
    |> validate_email(:email)
    # |> validate_document(:document)
    # |> validate_confirmation(:password)
    # |> new_password_validation
    |> sanitize_trial_expiration_date
    |> validate_trial_expiration_date
    |> put_encrypted_password
    |> unique_constraint(:email, name: "index_users_on_email")
  end

  defp sanitize_trial_expiration_date(changeset) do
    changeset
    |> get_change(:account_type)
    |> case do
      "FULL" -> changeset |> put_change(:trial_expiration_date, nil)
      _ -> changeset
    end
  end

  defp validate_trial_expiration_date(changeset) do
    changeset
    |> get_change(:account_type)
    |> case do
      "TRIAL" ->
        today = "America/Sao_Paulo" |> Timex.now() |> Timex.to_date()
        trial_expiration_date = get_change(changeset, :trial_expiration_date)

        if Timex.compare(today, trial_expiration_date, :days) == 1 do
          add_error(changeset, :trial_expiration_date, "Data inválida de expiração do TRIAL")
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  def password_reset_changeset(%User{} = user, token) do
    user
    |> change()
    |> put_change(:reset_password_token, token)
    |> put_change(:reset_password_sent_at, DateTime.utc_now() |> DateTime.truncate(:second))
  end

  def update_password_changeset(%User{} = user, %{current_password: _} = attrs) do
    user
    |> cast(attrs, [:current_password, :password, :password_confirmation])
    |> validate_required([:current_password, :password, :password_confirmation])
    |> validate_confirmation(:password, required: true)
    |> check_password(user)
    |> update_password_if_present()
  end

  def update_password_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:password, :password_confirmation])
    |> update_password_if_present()
  end

  def external_auth_token_changeset(%User{} = user, token) do
    user
    |> change()
    |> put_change(:auth_token, token)
  end

  # defp new_password_validation(changeset) do
  #   changeset |> validate_length(:password, min: 8)
  # end

  defp check_password(changeset, user) do
    current_password = get_change(changeset, :current_password)

    if Bcrypt.verify_pass(current_password, user.encrypted_password) do
      changeset
    else
      add_error(changeset, :current_password, "Senha atual inválida")
    end
  end

  defp update_password_if_present(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      _ ->
        changeset
        |> validate_required([:password])
        # |> new_password_validation
        |> put_encrypted_password
        |> put_change(:reset_password_token, nil)
        |> put_change(:reset_password_sent_at, nil)
    end
  end

  defp put_encrypted_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        changeset
        |> put_change(:encrypted_password, Bcrypt.hash_pwd_salt(password))
        |> delete_change(:password)

      _ ->
        changeset
    end
  end
end
