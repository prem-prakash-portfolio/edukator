defmodule EdukatorWeb.Resolvers.TrainingResolver do
  @moduledoc false
  alias Edukator.Trainings
  alias Edukator.QuestionFilter

  # def list(_parent, args, %{
  #       context: %{current_user: current_user, tenant: tenant}
  #     }) do
  #   {:ok, Trainings.list_trainings(args, current_user, tenant)}
  # end
  #
  # def list(_parent, _args, _context), do: {:error, %{key: "auth", messages: "Unauthenticated"}}
  #
  def show(_parent, args, %{
        context: %{current_user: current_user, tenant: tenant}
      }) do
    case Trainings.get_training!(args[:id], current_user, tenant) do
      nil -> {:error, "Not found"}
      training -> {:ok, training}
    end
  end

  def show(_parent, _args, _context), do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def filter(_parent, args, %{
        context: %{current_user: current_user, tenant: tenant}
      }) do
    {:ok, QuestionFilter.filter(args, current_user, tenant)}
  end

  def filter(_parent, _args, _context), do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def create_training(_parent, args, %{
        context: %{current_user: current_user, tenant: tenant}
      }) do
    Trainings.create_training(args, current_user, tenant)
  end

  def create_training(_parent, _args, _context),
    do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def delete_training(_parent, args, %{
        context: %{current_user: current_user, tenant: tenant}
      }) do
    Trainings.delete_training(args, current_user, tenant)
  end

  def delete_training(_parent, _args, _context),
    do: {:error, %{key: "auth", messages: "Unauthenticated"}}
end
