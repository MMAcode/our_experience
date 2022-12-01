defmodule OurExperience.Repo do
  use Ecto.Repo,
    otp_app: :our_experience,
    adapter: Ecto.Adapters.Postgres
end
