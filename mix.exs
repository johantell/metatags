defmodule Metatags.Mixfile do
  use Mix.Project

  def project do
    [
      app: :metatags,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:phoenix_html, "~> 2.9.3"},
      {:excoveralls, "~> 0.6", only: :test}
    ]
  end
end
