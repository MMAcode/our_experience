import Config
dbg()
# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.

# Miro config
config :our_experience, Miro,
  logout_url: "https://ourexperience.info" # www. is missing here (and everywhere else!)

config :our_experience, OurExperienceWeb.Endpoint,
  url: [host: "ourexperience.info", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Configures Swoosh API Client
config :swoosh, :api_client, OurExperience.Finch

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
import_config "prod.secret.exs"
