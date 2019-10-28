import Config

config :spigot, Spigot.Robot,
  name: System.fetch_env!("EVENTBOT_USERNAME"),
  password: System.fetch_env!("EVENTBOT_PASSWORD"),
  jid: System.fetch_env!("EVENTBOT_JID"),
  aka: System.fetch_env!("EVENTBOT_ALIAS"),
  rooms:
    System.fetch_env!("EVENTBOT_ROOMS")
    |> String.split(":")
    |> Enum.map(fn t -> {t, []} end),
  ssl_opts: [
    verify: :verify_peer,
    server_name_indication:
      System.fetch_env!("EVENTBOT_TLS_SNI") |> String.to_charlist(),
    cacertfile: "/etc/ssl/certs/ca-certificates.crt",
    depth: 2
  ]

config :runlet,
  riemann_host: System.get_env("EVENTBOT_RIEMANN_HOST", "localhost"),
  riemann_port: System.get_env("EVENTBOT_RIEMANN_PORT", "8080"),
  riemann_url: System.get_env("EVENTBOT_RIEMANN_URL", "/event/index?query="),
  root: System.get_env("EVENTBOT_PRX_ROOTDIR", "priv/root"),
  exec: System.get_env("EVENTBOT_PRX_EXEC", "")
