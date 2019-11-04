defmodule Agora.MixProject do
  use Mix.Project

  def project do
    [
      app: :agora,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),

      name: "Agora",
      docs: [
        main: "readme",
        extras: ["README.md", "requirements.md", "EXTENSION_POINTS.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Agora.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:jason, "1.1.2"},
      {:nanoid, "2.0.2"},
      {:plug, "~> 1.8"},
      {:plug_cowboy, "~> 2.1"}
    ]
  end

  defp aliases do
    [
      "db.clean": &db_clean/1
    ]
  end

  defp db_clean(_), do: System.cmd("rm", ["-r", "priv/db/#{Mix.env()}.mnesia"])
end
