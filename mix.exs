defmodule Eventbot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :eventbot,
      version: "2.1.1",
      elixir: "~> 1.9",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Interact with event streams using XMPP",
      dialyzer: [
        plt_add_deps: :app_tree,
        paths: [
          "_build/dev/lib/runlet/ebin",
          "_build/dev/lib/runlet_sh/ebin",
          "_build/dev/lib/spigot/ebin"
        ]
      ],
      default_release: :eventbot,
      releases: [
        eventbot: [
          strip_beams: false,
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent]
        ]
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  # def application do
  #  [extra_applications: [:runtime_tools]]
  # end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:alcove, "~> 0.40.5", override: true},
      {:prx, "~> 0.16.3", override: true},
      {:romeo, git: "https://github.com/kerryb/romeo.git", override: true},
      {:hedwig_xmpp,
       github: "msantos/hedwig_xmpp", branch: "crash", override: true},
      {:fast_xml, "~> 1.1.49", override: true, manager: :rebar3},
      {:spigot, github: "msantos/spigot"},
      {:runlet, "~> 1.2.2", override: true},
      {:runlet_sh, github: "msantos/runlet_sh"},
      {:runlet_net, github: "msantos/runlet_net"},
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
    ]
  end
end
