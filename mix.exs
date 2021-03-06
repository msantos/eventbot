defmodule Eventbot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :eventbot,
      version: "2.0.0",
      elixir: "~> 1.9",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Interact with event streams using XMPP",
      dialyzer: [
        list_unused_filters: true,
        flags: [
          "-Wunmatched_returns",
          :error_handling,
          :race_conditions,
          :underspecs
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
      {:romeo, github: "scrogson/romeo", override: true},
      {:hedwig_xmpp,
       github: "msantos/hedwig_xmpp", branch: "crash", override: true},
      {:fast_xml, "~> 1.1.29",
       [env: :prod, repo: "hexpm", hex: "fast_xml", override: true]},
      {:spigot, github: "msantos/spigot"},
      {:runlet, "~> 1.0", override: true},
      {:runlet_sh, github: "msantos/runlet_sh"},
      {:runlet_net, github: "msantos/runlet_net"},
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev], runtime: false},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end
end
