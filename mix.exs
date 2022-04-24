defmodule Unplug.MixProject do
  use Mix.Project

  def project do
    [
      app: :unplug,
      version: "1.0.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "Unplug",
      source_url: "https://github.com/akoutmos/unplug",
      homepage_url: "https://hex.pm/packages/unplug",
      description: "A plug that can be used to conditionally invoke other plugs",
      start_permanent: Mix.env() == :prod,
      docs: docs(),
      package: package(),
      deps: deps(),
      aliases: aliases(),
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

  defp package do
    [
      name: "unplug",
      files: ~w(lib mix.exs README.md LICENSE CHANGELOG.md),
      licenses: ["MIT"],
      maintainers: ["Alex Koutmos"],
      links: %{
        "GitHub" => "https://github.com/akoutmos/unplug",
        "Sponsor" => "https://github.com/sponsors/akoutmos"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "master",
      logo: "guides/images/logo.svg",
      extras: ["README.md"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # doProduction deps
      {:plug, "~> 1.8"},

      # Development deps
      {:ex_doc, "~> 0.28.2", only: :dev},
      {:excoveralls, "~> 0.14.4", only: [:test, :dev], runtime: false},
      {:doctor, "~> 0.18.0", only: :dev},
      {:credo, "~> 1.6.1", only: :dev},
      {:git_hooks, "~> 0.7.3", only: [:test, :dev], runtime: false}
    ]
  end

  defp aliases do
    [
      docs: [&massage_readme/1, "docs", &copy_files/1]
    ]
  end

  defp copy_files(_) do
    # Set up directory structure
    File.mkdir_p!("./doc/guides/images")

    # Copy over image files
    "./guides/images/"
    |> File.ls!()
    |> Enum.each(fn image_file ->
      File.cp!("./guides/images/#{image_file}", "./doc/guides/images/#{image_file}")
    end)

    # Clean up previous file massaging
    File.rm!("./README.md")
    File.rename!("./README.md.orig", "./README.md")
  end

  defp massage_readme(_) do
    hex_docs_friendly_header_content = """
    <br>
    <img align="center" width="25%" src="guides/images/logo.svg" alt="Unplug Logo" style="margin-left:33%">
    <img align="center" width="55%" src="guides/images/logo_text.png" alt="Unplug Logo" style="margin-left:15%">
    <br>
    <div align="center">Conditionally execute your plug modules at run-time in your Phoenix/Plug applications!</div>
    <br>
    --------------------

    [![Hex.pm](https://img.shields.io/hexpm/v/unplug?style=for-the-badge)](http://hex.pm/packages/unplug)
    [![Build Status](https://img.shields.io/github/workflow/status/akoutmos/unplug/Unplug%20CI/master?label=Build%20Status&style=for-the-badge)](https://github.com/akoutmos/unplug/actions)
    [![Coverage Status](https://img.shields.io/coveralls/github/akoutmos/unplug/master?style=for-the-badge)](https://coveralls.io/github/akoutmos/prom_ex?branch=master)
    [![Support Unplug](https://img.shields.io/badge/Support%20Unplug-%E2%9D%A4-lightblue?style=for-the-badge)](https://github.com/sponsors/akoutmos)
    """

    File.cp!("./README.md", "./README.md.orig")

    readme_contents = File.read!("./README.md")

    massaged_readme =
      Regex.replace(~r/<!--START-->(.|\n)*<!--END-->/, readme_contents, hex_docs_friendly_header_content)

    File.write!("./README.md", massaged_readme)
  end
end
