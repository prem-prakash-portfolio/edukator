import Config

config :polymata, Edukator.Mailer, adapter: Swoosh.Adapters.Local, serve_mailbox: true
