import Config

config :tesla, ExUrlbox, adapter: Tesla.Mock

config :ex_urlbox,
  api_key: "fakeAPIkey",
  api_secret: "fakeAPIsecret"

config :logger, level: :info
