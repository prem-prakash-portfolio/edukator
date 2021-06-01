defmodule Edukator.Repo do
  use Ecto.Repo,
    otp_app: :polymata,
    adapter: Ecto.Adapters.Postgres

  use CursorPaginator
end
