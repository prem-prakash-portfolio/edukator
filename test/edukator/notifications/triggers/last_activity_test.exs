defmodule Edukator.Notifications.Triggers.LastActivityTest do
  use Edukator.DataCase
  import Edukator.Factory

  alias Edukator.Notifications.Triggers.LastActivity

  test "should filter users correctly" do
    four_days_ago =
      "America/Sao_Paulo"
      |> Timex.now()
      |> Timex.shift(days: -4)
      |> Timex.beginning_of_day()
      |> Timex.to_datetime()

    two_days_ago =
      "America/Sao_Paulo"
      |> Timex.now()
      |> Timex.shift(days: -2)
      |> Timex.beginning_of_day()
      |> Timex.to_datetime()

    user_to_receive_email = insert(:user)
    user_to_not_receive_email = insert(:user)

    insert(:event, user: user_to_receive_email, created_at: four_days_ago)
    insert(:event, user: user_to_not_receive_email, created_at: four_days_ago)
    insert(:event, user: user_to_not_receive_email, created_at: two_days_ago)

    result = LastActivity.users_last_activity(3, "public")

    assert Enum.count(result) == 1

    [event | _] = result

    assert Date.compare(event.date, DateTime.to_date(four_days_ago)) == :eq

    assert event.user.email == user_to_receive_email.email
  end
end
