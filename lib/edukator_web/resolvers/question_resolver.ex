defmodule EdukatorWeb.Resolvers.QuestionResolver do
  @moduledoc false
  alias Edukator.Questions

  def tags(parent, _args, %{
        context: %{current_user: _user, tenant: tenant}
      }) do
    {:ok, Questions.list_tags(parent, tenant)}
  end

  def tags(_parent, _args, _context), do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def list(parent, _args, %{
        context: %{current_user: _user, tenant: tenant}
      }) do
    {:ok, Questions.list_questions(parent, tenant)}
  end

  def list(_parent, _args, _context), do: {:error, %{key: "auth", messages: "Unauthenticated"}}

  def comment(parent, _args, %{
        context: %{current_user: _user, tenant: tenant}
      }) do
    {:ok, Questions.get_comment!(parent, tenant)}
  end

  def teacher(parent, _args, %{
        context: %{current_user: _user, tenant: tenant}
      }) do
    {:ok, Questions.get_teacher!(parent, tenant)}
  end

  def show(_parent, args, %{context: %{current_user: user, tenant: tenant}}) do
    args = Map.put(args, :user_id, user.id)
    {:ok, Questions.get_question!(args, tenant)}
  end

  def show(_parent, _args, _context), do: {:error, %{key: "auth", messages: "Unauthenticated"}}
end
