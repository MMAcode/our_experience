import Config
config :our_experience, OurExperienceWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT")),
    transport_options: [socket_opts: [:inet6]]
  ]
