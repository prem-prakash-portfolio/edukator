defmodule Edukator.Repo.Migrations.RenameTagKind do
  use Ecto.Migration

  def change do
    execute("""
    UPDATE tags SET kind = 'Discipline' WHERE kind = 'discipline';
    """)

    execute("""
    UPDATE tags SET kind = 'Subject' WHERE kind = 'subject';
    """)

    execute("""
    UPDATE tags SET kind = 'Video' WHERE kind = 'resolution_video_url';
    """)
  end
end
