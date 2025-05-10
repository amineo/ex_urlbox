defmodule ExUrlbox.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_urlbox,
      version: "0.2.0",
      elixir: "~> 1.16",
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
      {:tesla, "~> 1.14"},
      {:hackney, "~> 1.23"},
      {:jason, "~> 1.4"},
      # Docs, code quality, style and linting
      {:ex_doc, "~> 0.37", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:mox, "~> 1.2", only: :test}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/amineo/ex_urlbox"}
    ]
  end
end
