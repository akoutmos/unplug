defmodule Unplug.MixProject do
  use Mix.Project

  def project do
    [
      app: :unplug,
      version: "0.1.0",
      elixir: "~> 1.8",
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
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
