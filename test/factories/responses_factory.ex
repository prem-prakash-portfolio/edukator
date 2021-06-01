defmodule Edukator.ResponsesFactory do
  @moduledoc """
  Factory for modules inside the `Responses` context
  """

  defmacro __using__(_opts) do
    quote do
      def response_factory do
        %Edukator.Responses.Response{
          question: build(:question),
          question_alternative: build(:question_alternative)
        }
      end
    end
  end
end
