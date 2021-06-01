defmodule EdukatorWeb.Schema.ExamTypes do
  @moduledoc false
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]
  alias DeliriumTremex.Middleware.HandleErrors
  alias EdukatorWeb.{Data, Resolvers}

  @desc "An exam"
  object :exam do
    field(:id, :id)
    field :name, :string
    field :area, :string
    field :edition, :string
    field :exam_questions_count, :integer
    field :speciality, :string
    field :year, :string
    field :educational_level, :string
    field :exam_sessions, list_of(:exam_session)
    field :author, :author, resolve: dataloader(Data, :author)
    field :job, :job, resolve: dataloader(Data, :job)
    field :organization, :organization, resolve: dataloader(Data, :organization)
  end

  @desc "Author (Banca)"
  object :author do
    field :id, :id
    field :name, :string
  end

  @desc "Job (Cargo)"
  object :job do
    field :id, :id
    field :name, :string
  end

  @desc "Organization (Instituição)"
  object :organization do
    field :id, :id
    field :name, :string
  end

  @desc "Organizations and Jobs for Goals"
  object :organizations_and_jobs do
    field :organizations, list_of(:organization)
    field :jobs, list_of(:job)
  end

  object :exam_queries do
    @desc "Query for Organizations and Jobs for Goals"
    field :organizations_and_jobs, :organizations_and_jobs do
      resolve(&Resolvers.ExamResolver.organizations_and_jobs/3)
      middleware(HandleErrors)
    end
  end
end
