import Config

config :ex_urlbox,
  api_key: {:system, "URLBOX_API_KEY"},
  api_secret: {:system, "URLBOX_API_SECRET"}

config :logger, level: :info
