use Mix.Config

config :mnesia,
  dir: 'priv/db/#{Mix.env()}.mnesia'

config :agora, AgoraWeb.Endpoint,
  secret_key_base: "7NjxIZ613ukXcLSfYbfWLALskqnvXkMqELTkbBN1+oNK7WogDpz2hYpcpiL6xXOO",
  pubsub: [name: Agora.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

import_config "#{Mix.env()}.exs"
