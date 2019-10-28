# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :runlet, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:runlet, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info

config :spigot, Spigot.Robot,
  adapter: Hedwig.Adapters.XMPP,
  name: {:system, "EVENTBOT_USERNAME"},
  password: {:system, "EVENTBOT_PASSWORD"},
  jid: {:system, "EVENTBOT_JID"},
  aka: {:system, "EVENTBOT_ALIAS"},
  rooms: {:system, "EVENTBOT_ROOMS"},
  ssl_opts: [
    verify: :verify_peer,
    server_name_indication: 'xmpp.example.com',
    cacertfile: "/etc/ssl/certs/ca-certificates.crt",
    depth: 2
  ],
  responders: [
    {Spigot.Responders.Runlet, []}
  ]

config :runlet,
  riemann_host: {:system, "EVENTBOT_RIEMANN_HOST", "localhost"},
  riemann_port: {:system, "EVENTBOT_RIEMANN_PORT", 8080},
  riemann_url: {:system, "EVENTBOT_RIEMANN_URL", "/event/index?query="},
  statedir: "priv/state",
  root: {:system, "EVENTBOT_PRX_ROOTDIR", "priv/root"},
  exec: {:system, "EVENTBOT_PRX_EXEC", ""},
  aliases: [
    {"info", {[:Spigot, :Ctrl, :Info], :exec}},
    {"whoami", {[:Spigot, :Ctrl, :Whoami], :exec}},
    {"version", {[:Spigot, :Ctrl, :Version], :exec}},
    {"exit", {[:Runlet, :Ctrl, :Exit], :exec}},
    {"hd", {[:Runlet, :Ctrl, :HistoryDelete], :exec}},
    {"help", {[:Runlet, :Ctrl, :Help], :exec}},
    {"h", {[:Runlet, :Ctrl, :History], :exec}},
    {"H", {[:Runlet, :Ctrl, :HistoryUser], :exec}},
    {"kill", {[:Runlet, :Ctrl, :Kill], :exec}},
    {"ps", {[:Runlet, :Ctrl, :Ps], :exec}},
    {"reflow", {[:Runlet, :Ctrl, :Flow], :exec}},
    {"refmt", {[:Runlet, :Ctrl, :Fmt], :exec}},
    {"start", {[:Runlet, :Ctrl, :Start], :exec}},
    {"stop", {[:Runlet, :Ctrl, :Stop], :exec}},
    {"hup", {[:Runlet, :Ctrl, :Signal], :exec}},
    {"signal", {[:Runlet, :Ctrl, :Signal], :exec}},
    {"halt", {[:Runlet, :Ctrl, :Halt], :exec}},
    {"reboot",
     [
       {{[:Runlet, :Ctrl, :Halt], :exec}, [2]}
     ]},
    {"Ps",
     [
       {{[:Runlet, :Ctrl, :Ps], :exec}, ["-a"]}
     ]},
    {"query",
     [
       {[:Runlet, :Cmd, :Query], :exec},
       {{[:Runlet, :Cmd, :Valve], :exec}, []},
       {{[:Runlet, :Cmd, :Flow], :exec}, [20, 100]}
     ]},
    {~S(\query),
     [
       {[:Runlet, :Cmd, :Query], :exec}
     ]},
    {"sh",
     [
       {[:Runlet, :Cmd, :Sh], :exec},
       {{[:Runlet, :Cmd, :Valve], :exec}, []},
       {{[:Runlet, :Cmd, :Flow], :exec}, [20, 100]}
     ]},
    {~S(\sh),
     [
       {[:Runlet, :Cmd, :Sh], :exec}
     ]},
    {"x",
     [
       {[:Runlet, :Cmd, :Sh], :exec},
       {{[:Runlet, :Cmd, :Valve], :exec}, []},
       {{[:Runlet, :Cmd, :Flow], :exec}, [20, 100]}
     ]},
    {~S(\x),
     [
       {[:Runlet, :Cmd, :Sh], :exec}
     ]},
    {"runtime", {[:Runlet, :Cmd, :Runtime], :exec}},
    {"ipaddr",
     [
       {{[:Runlet, :Cmd, :HTTP], :exec}, ['http://icanhazip.com']}
     ]},
    {"tls", {[:Runlet, :Cmd, :TLS], :exec}},
    {"abort", {[:Runlet, :Cmd, :Abort], :exec}},
    {"dedup", {[:Runlet, :Cmd, :Dedup], :exec}},
    {"filter", {[:Runlet, :Cmd, :Filter], :exec}},
    {"flow", {[:Runlet, :Cmd, :Flow], :exec}},
    {"fmt", {[:Runlet, :Cmd, :Fmt], :exec}},
    {"grep", {[:Runlet, :Cmd, :Grep], :exec}},
    {"limit", {[:Runlet, :Cmd, :Limit], :exec}},
    {"over", {[:Runlet, :Cmd, :Threshold], :exec}},
    {"rate", {[:Runlet, :Cmd, :Rate], :exec}},
    {"select", {[:Runlet, :Cmd, :Select], :exec}},
    {"stdin", {[:Runlet, :Cmd, :Stdin], :exec}},
    {"suppress", {[:Runlet, :Cmd, :Suppress], :exec}},
    {"take", {[:Runlet, :Cmd, :Take], :exec}},
    {"threshold", {[:Runlet, :Cmd, :Threshold], :exec}},
    {"thresh", {[:Runlet, :Cmd, :Threshold], :exec}},
    {"timeout", {[:Runlet, :Cmd, :Timeout], :exec}},
    {"valve", {[:Runlet, :Cmd, :Valve], :exec}},
    {">", {[:Runlet, :Cmd, :Stdin], :exec}}
  ],
  riemann_event: [
    Runlet.Event.Stdio,
    Runlet.Event.Riemann
  ]
