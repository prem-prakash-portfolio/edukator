defmodule Edukator.Notifications.Triggers.ExpirationDateTest do
  use Edukator.DataCase
  import Edukator.Factory
  alias Edukator.Notifications.Triggers.ExpirationDate

  describe "run/3" do
    test "should send email" do
      qty = Enum.random(3..5)
      date = "America/Sao_Paulo" |> Timex.now() |> Timex.to_date() |> Timex.shift(days: 3)
      users = insert_list(qty, :user, account_type: "TRIAL", trial_expiration_date: date)

      insert(:notification_type,
        identifier: "trial_close_to_expiration",
        title_template: "Está gostando? Assine"
      )

      Swoosh.Adapters.Local.Storage.Memory.delete_all()

      ExpirationDate.run("trial_close_to_expiration", 3)

      sent_emails = Swoosh.Adapters.Local.Storage.Memory.all()

      assert Enum.count(sent_emails) == qty

      assert Enum.all?(users, fn %{email: email, name: name} ->
               Enum.any?(sent_emails, &(&1.to == [{name, email}]))
             end) == true
    end
  end
end
