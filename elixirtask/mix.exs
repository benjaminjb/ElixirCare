defmodule Elixirtask.Mixfile do
  use Mix.Project

  def project do
    [app: :elixirtask,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  def application do
    [applications: [:logger, :cberl, :poison, :cowboy, :plug]]
    #  mod: {Bond, []}]
  end

  defp deps do
    [
      {:cberl, github: "chitika/cberl"},
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 0.8.1"},
      {:poison, "~> 1.2.0", override: true}      
    ]
  end
end