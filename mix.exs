defmodule Coniglio.MixProject do
  use Mix.Project

  def project do
    [
      app: :coniglio,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def elixirc_paths(:test) do
    ["lib", "test"]
  end

  def elixirc_paths(_) do
    ["lib"]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :amqp]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:amqp, "~> 1.3"},
      {:protobuf, "~> 0.5.3"},
      {:uuid, "~> 1.1"},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
