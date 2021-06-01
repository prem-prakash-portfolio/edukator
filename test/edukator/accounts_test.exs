defmodule Edukator.AccountsTest do
  use Edukator.DataCase
  import Edukator.Factory

  alias Edukator.Accounts

  describe "validate_trial_expiration_date/1" do
    test "when TRIAL not expired" do
      date = "America/Sao_Paulo" |> Timex.now() |> Timex.to_date() |> Timex.shift(days: 3)
      args = insert(:user, account_type: "TRIAL", trial_expiration_date: date)
      assert Accounts.validate_trial_expiration_date(args) == :ok
    end

    test "when TRIAL not expired passing a map" do
      date =
        "America/Sao_Paulo"
        |> Timex.now()
        |> Timex.to_date()
        |> Timex.shift(days: 3)
        |> Timex.format!("{YYYY}-{0M}-{D}")

      args = %{account_type: "TRIAL", trial_expiration_date: date}
      assert Accounts.validate_trial_expiration_date(args) == :ok
    end

    test "when TRIAL expired" do
      date = "America/Sao_Paulo" |> Timex.now() |> Timex.to_date() |> Timex.shift(days: -3)
      args = insert(:user, account_type: "TRIAL", trial_expiration_date: date)
      assert Accounts.validate_trial_expiration_date(args) == {:error, :trial_expired}
    end

    test "when not TRIAL" do
      args = insert(:user, account_type: "FULL")
      assert Accounts.validate_trial_expiration_date(args) == :ok
    end
  end
end
