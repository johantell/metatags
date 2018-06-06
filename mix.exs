defmodule Metatags.Mixfile do
  use Mix.Project

  def project do
    [
      app: :metatags,
      version: "0.1.2",
      elixir: "~> 1.4",
      deps: deps(),
      description: description(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
    ]
  end

  defp deps do
    [
      {:phoenix_html, "~> 2.9"},

      {:ex_doc, "~> 0.16", only: :dev},
      {:dogma, "~> 0.1", only: :dev},

      {:excoveralls, "~> 0.7", only: :test}
    ]
  end

  defp description do
    """
    Metatags provides an easy to work with API to set default and
    page specific metatags on a page.
    """
  end

  defp package do
    [
      name: :metatags,
      description: description(),
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["johan Tell"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mintcore/metatags"}
    ]
  end
end
