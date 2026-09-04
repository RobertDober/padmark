defmodule Padmark.Mixfile do
  use Mix.Project

  @version "1.4.49"

  @url "https://github.com/lambdapad/padmark"

  @deps [
    {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
    {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
    {:doctor, "~> 0.21", only: [:dev, :test], runtime: false},
    {:earmark_ast_dsl, "~> 0.3.6", only: [:dev, :test]},
    {:ex_check, "~> 0.16", only: [:dev, :test], runtime: false},
    {:ex_doc, "~> 0.38.2", only: [:dev]},
    {:floki, "~> 0.21", only: [:dev, :test]},
    {:traverse, "~> 1.0.1", only: [:dev, :test]}
  ]

  @description """
  Padmark is a pure-Elixir Markdown converter.

  It is intended to be used as a library (just call Padmark.as_html),
  but can also be used as a command-line tool (run mix escript.build
  first).

  Output generation is pluggable.
  """

  ############################################################

  def project do
    [
      app: :padmark,
      version: @version,
      compilers: [:leex, :yecc] ++ Mix.compilers(),
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      escript: escript_config(),
      deps: @deps,
      description: @description,
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:eex]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support", "dev"]
  defp elixirc_paths(:dev), do: ["lib", "lib1", "dev"]
  defp elixirc_paths(_), do: ["lib", "lib1"]

  defp escript_config do
    [main_module: Padmark.Cli]
  end

  defp package do
    [
      files: [
        "lib",
        "lib1",
        "src/*.xrl",
        "src/*.yrl",
        "mix.exs",
        "README.md"
      ],
      maintainers: [
        "Robert Dober <robert.dober@gmail.com>",
        "Dave Thomas <dave@pragdave.me>"
      ],
      licenses: [
        "Apache-2.0"
      ],
      links: %{
        "GitHub" => "https://github.com/lambdapad/padmark"
      }
    ]
  end

  defp docs() do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @url,
      extras: ["README.md", "RELEASE.md", "LICENSE"]
    ]
  end
end

# SPDX-License-Identifier: Apache-2.0
