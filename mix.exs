defmodule ExUrlbox.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_urlbox,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "ExUrlbox",
      description: "A light wrapper for the Urlbox API",
      source_url: "https://github.com/amineo/ex_urlbox",
      homepage_url: "https://github.com/amineo/ex_urlbox",
      docs: [
        main:  "ExUrlbox",
        extras: ["README.md"]
      ],
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.28.0"},
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:jason, ">= 1.0.0"},
      # Code quality, style and linting
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:mox, "~> 1.0", only: :test}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/amineo/ex_urlbox"}
    ]
  end
end
