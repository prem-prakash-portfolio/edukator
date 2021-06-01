defmodule Edukator.Repo.Migrations.ConvertAllNonTimezoneDatetimeFieldsToTimezoned do
  use Ecto.Migration

  def change do
    alter table(:authors) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:exam_questions) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:exam_sessions) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:exams) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:jobs) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:notification_messages) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
      modify(:viewed_at, :utc_datetime)
      modify(:deleted_at, :utc_datetime)
    end

    alter table(:notification_types) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:organizations) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:question_alternatives) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:questions) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:responses) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:tags) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:training_questions) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:trainings) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
    end

    alter table(:users) do
      modify(:created_at, :utc_datetime)
      modify(:updated_at, :utc_datetime)
      modify(:reset_password_sent_at, :utc_datetime)
      modify(:remember_created_at, :utc_datetime)
      modify(:current_sign_in_at, :utc_datetime)
      modify(:last_sign_in_at, :utc_datetime)
      modify(:confirmed_at, :utc_datetime)
      modify(:confirmation_sent_at, :utc_datetime)
      modify(:locked_at, :utc_datetime)
    end
  end
end
