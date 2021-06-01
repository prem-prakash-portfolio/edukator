defmodule Edukator.ExamSessionsFactory do
  @moduledoc """
  Factory for modules inside the `ExamSessions` context
  """

  defmacro __using__(_opts) do
    quote do
      def exam_session_factory do
        %Edukator.ExamSessions.ExamSession{}
      end
    end
  end
end
