defmodule Edukator.EventsFactory do
  @moduledoc """
  Factory for modules inside the `Events` context
  """

  defmacro __using__(_opts) do
    quote do
      def event_factory do
        %Edukator.Events.Event{
          category: "Exams",
          action: "Started Exam",
          label: "Exam",
          value: "Simulado UFRJ",
          properties: %{"examName" => "Simulado UFRJ"}
        }
      end
    end
  end
end
