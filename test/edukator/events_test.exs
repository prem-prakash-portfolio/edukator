defmodule Edukator.EventsTest do
  use Edukator.DataCase
  import Edukator.Factory

  alias Edukator.Events
  alias Edukator.Events.Event

  describe "track_event/2" do
    test "create event with integer value" do
      events_count = Repo.aggregate(Event, :count, :id)

      user = insert(:user)

      params = %{
        "category" => "Exams",
        "action" => "Started Exam",
        "label" => "Exam",
        "value" => 1,
        "properties" => %{"examName" => "Simulado UFRJ"}
      }

      Events.track_event(user, params)
      post_insert_events_count = Repo.aggregate(Event, :count, :id)

      assert post_insert_events_count == events_count + 1
    end

    test "create event with string value" do
      events_count = Repo.aggregate(Event, :count, :id)

      user = insert(:user)

      params = %{
        "category" => "Exams",
        "action" => "Started Exam",
        "label" => "Exam",
        "value" => "string value",
        "properties" => %{"examName" => "Simulado UFRJ"}
      }

      Events.track_event(user, params)
      post_insert_events_count = Repo.aggregate(Event, :count, :id)

      assert post_insert_events_count == events_count + 1
    end
  end
end
