defmodule Elixircare.Mixfile do
  use Mix.Project

  def project do
    [app: :elixircare,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :cowboy, :plug, :cberl]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:cowboy,           "~> 1.0.0"},
      {:plug,             "~> 0.8.3"},
      {:plug_basic_auth,  "~> 0.2.2"},
      {:couchie,          github: "clutchanalytics/couchie", override: true, tag: "0.13.0"},
      {:jazz,             github: "meh/jazz", override: true},
      {:cberl,            github: "chitika/cberl"}
    ]
  end
end
