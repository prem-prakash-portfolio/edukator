defmodule Edukator.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @timestamps_opts [inserted_at: :created_at]
    end
  end
end
