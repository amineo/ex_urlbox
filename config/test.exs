import Config

config :tesla, ExUrlbox, adapter: Tesla.Mock

config :ex_urlbox,
  api_key: "fakeAPIkey",
  api_secret: "fakeAPIsecret",
  env: :test

config :logger, level: :info
