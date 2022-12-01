import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :our_experience, OurExperience.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "our_experience_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :our_experience, OurExperienceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "MRaIr6fO1KH7dch8PCCX/8PJiur+tU0MEc05a5oOADntxWWkQYonw7ryuDOwURdV",
  server: false

# In test we don't send emails.
config :our_experience, OurExperience.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# if System.get_env("CI") do
#   import_config "test.secret.exs" # file currently does not exist
# end
