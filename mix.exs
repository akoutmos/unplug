defmodule Unplug.MixProject do
  use Mix.Project

  def project do
    [
      app: :unplug,
      version: "0.1.1",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "Unplug",
      source_url: "https://github.com/akoutmos/unplug",
      homepage_url: "https://hex.pm/packages/unplug",
      description: "A plug that can be used to conditionally invoke other plugs",
      start_permanent: Mix.env() == :prod,
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.travis": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/test_plugs", "test/test_predicates"]
  defp elixirc_paths(_), do: ["lib"]

  defp package() do
    [
      name: "unplug",
      files: ~w(lib mix.exs README.md LICENSE CHANGELOG.md),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/akoutmos/unplug"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.8"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:excoveralls, "~> 0.12", only: :test, runtime: false}
    ]
  end
end
