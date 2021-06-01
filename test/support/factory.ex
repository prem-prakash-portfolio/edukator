defmodule Edukator.Factory do
  @moduledoc """
  Module that loads all factories used on our tests, so that when we do
  > use Edukator.Factory
  all of these modules will be loaded
  """

  use ExMachina.Ecto, repo: Edukator.Repo
  use Edukator.AccountsFactory
  use Edukator.QuestionsFactory
  use Edukator.ExamsFactory
  use Edukator.TrainingsFactory
  use Edukator.ExamSessionsFactory
  use Edukator.ResponsesFactory
  use Edukator.NotificationsFactory
  use Edukator.EventsFactory
end
