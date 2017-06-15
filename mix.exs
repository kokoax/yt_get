defmodule YtGet.Mixfile do
  use Mix.Project

  def project do
    [app: :yt_get,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: YtGet],
     deps: deps()]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.11.1"},
      {:floki, "~> 0.17.0"}
    ]
  end
end
