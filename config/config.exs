# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config
# dbg(config_env())
config :our_experience,
  ecto_repos: [OurExperience.Repo]

# Configures the endpoint
config :our_experience, OurExperienceWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: OurExperienceWeb.ErrorHTML, json: OurExperienceWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: OurExperience.PubSub,
  live_view: [signing_salt: "brl60QD3"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :our_experience, OurExperience.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.1.8",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


# Configures Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    auth0: { Ueberauth.Strategy.Auth0, [] },
    # auth0: { Ueberauth.Strategy.Auth0, [callback_path: "/"] },
  ]
import_config "secrets/auth0.secret.exs"



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
dbg(config_env())
