use Mix.Config

config :agora, AgoraWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ],
  live_view: [
    signing_salt: "7NjxIZ613ukXcLSfYbfWLALskqnvXkMqELTkbBN1+oNK7WogDpz2hYpcpiL6xXOO"
  ]

config :agora, AgoraWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/agora_web/controllers/.*(ex)$},
      ~r{lib/agora_web/live/.*(ex)$},
      ~r{lib/agora_web/views/.*(ex)$},
      ~r{lib/agora_web/templates/.*(eex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
