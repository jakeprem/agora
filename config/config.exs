use Mix.Config

config :mnesia,
  dir: 'priv/db/#{Mix.env()}.mnesia'
