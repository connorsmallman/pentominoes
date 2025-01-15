defmodule Pentominoes.Repo do
  use Ecto.Repo,
    otp_app: :pentominoes,
    adapter: Ecto.Adapters.Postgres
end
