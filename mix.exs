defmodule Metatags.Mixfile do
  use Mix.Project

  @description """
  Metatags provides an easy to work with API to set default and
  page specific metatags on a page.
  """

  def project do
    [
      app: :metatags,
      version: "0.2.1",
      elixir: "~> 1.4",
      deps: deps(),
      description: @description,
      package: package(),
      test_coverage: [
        tool: ExCoveralls,
      ],
      preferred_cli_env: [
        credo: :test,
        dialyzer: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  defp deps do
    [
      {:phoenix_html, "~> 2.9"},
      {:ex_doc, "~> 0.16", only: :dev},
      {:credo, ">= 0.0.0", only: :test, runtime: false},
      {:excoveralls, ">= 0.0.0", only: :test, runtime: false},
      {:dialyxir, "~> 0.5", only: :test, runtime: false}
    ]
  end

  defp package do
    [
      name: :metatags,
      description: @description,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["johan Tell"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/johantell/metatags"}
    ]
  end
end
