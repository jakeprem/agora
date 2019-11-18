use Mix.Config

config :agora, AgoraWeb.Endpoint,
  http: [port: 4002],
  server: false,
  live_view: [
    signing_salt: "7DZL7PtijcHETt4fNw2xzkE3neRgLpU/70V13GxxXP21COl9XhowZvpXOjzF/89K"
  ]
