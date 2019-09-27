defmodule Coniglio.MixProject do
  use Mix.Project

  def project do
    [
      app: :coniglio,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [plt_add_deps: :project],
      docs: [main: "Coniglio", logo: "assets/Bogs.png", extras: ["README.md"]]
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
      {:amqp, "~> 1.3.1"},
      {:protobuf, "~> 0.5.3"},
      {:uuid, "~> 1.1"},
      {:consul, "~> 0.1.6", hex: :consul_client},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
