defmodule Edukator.TrainingsFactory do
  @moduledoc """
  Factory for modules inside the `Trainings` context
  """

  defmacro __using__(_opts) do
    quote do
      def training_factory do
        %Edukator.Trainings.Training{
          name: "Meu treino",
          user: build(:user),
          questions_count: 30
        }
      end
    end
  end
end
