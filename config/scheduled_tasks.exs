import Config

config :polymata, Edukator.Scheduler,
  jobs: [
    {"0 12 * * *",
     fn ->
       Edukator.Notifications.Triggers.ExpirationDate.run("trial_close_to_expiration", 3)
     end},
    {"0 13 * * *",
     fn -> Edukator.Notifications.Triggers.ExpirationDate.run("trial_expired", -3) end},
    {"0 14 * * 3", fn -> Edukator.Notifications.Triggers.LastActivity.run("last_access", 3) end},
    {"0 15 * * 4,6",
     fn ->
       Edukator.Notifications.Triggers.UnfinishedExam.run("unfinished_exam", 3, 3)
     end},
    {"0 21 * * 0", fn -> Edukator.Notifications.Triggers.WeeklySummary.run("weekly_summary") end}
  ]
