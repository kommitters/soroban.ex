defmodule Soroban.MixProject do
  use Mix.Project

  @version "0.20.1"
  @github_url "https://github.com/kommitters/soroban.ex"

  def project do
    [
      app: :soroban,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Soroban",
      description: description(),
      source_url: @github_url,
      package: package(),
      docs: docs(),
      dialyzer: [
        plt_add_apps: [:soroban, :ex_unit, :jason],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
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
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:stellar_sdk, "~> 0.21"},
      {:hackney, "~> 1.18"}
    ]
  end

  defp description do
    """
    Elixir library to interact with the Soroban-RPC server, and facilitate the deployment and invocation of Soroban smart contracts.
    """
  end

  defp package do
    [
      description: description(),
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "#{@github_url}/blob/main/CHANGELOG.md",
        "GitHub" => @github_url,
        "Sponsor" => "https://github.com/sponsors/kommitters"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      name: "Soroban.ex",
      source_ref: "v#{@version}",
      source_url: @github_url,
      canonical: "https://hexdocs.pm/soroban",
      extras: extras(),
      groups_for_modules: groups_for_modules()
    ]
  end

  defp groups_for_modules do
    [
      Contract: [
        Soroban.Contract,
        Soroban.Contract.RPCCalls,
        Soroban.Contract.InvokeContractFunction,
        Soroban.Contract.UploadContractCode,
        Soroban.Contract.DeployContract,
        Soroban.Contract.DeployAssetContract,
        Soroban.Contract.ExtendFootprintTTL,
        Soroban.Contract.RestoreFootprint
      ],
      RPC: [
        Soroban.RPC,
        Soroban.RPC.Server,
        Soroban.RPC.Request,
        Soroban.RPC.GetTransaction,
        Soroban.RPC.GetTransactionResponse,
        Soroban.RPC.SendTransaction,
        Soroban.RPC.SendTransactionResponse,
        Soroban.RPC.SimulateTransaction,
        Soroban.RPC.SimulateTransactionResponse,
        Soroban.RPC.GetHealth,
        Soroban.RPC.GetHealthResponse,
        Soroban.RPC.GetLatestLedger,
        Soroban.RPC.GetLatestLedgerResponse,
        Soroban.RPC.GetNetwork,
        Soroban.RPC.GetNetworkResponse,
        Soroban.RPC.GetLedgerEntries,
        Soroban.RPC.GetLedgerEntriesResponse,
        Soroban.RPC.GetEvents,
        Soroban.RPC.GetEventsResponse,
        Soroban.RPC.EventFilter,
        Soroban.RPC.EventsPayload,
        Soroban.RPC.TopicFilter,
        Soroban.RPC.Error,
        Soroban.RPC.HTTPError
      ],
      Types: [
        Soroban.Types.Address,
        Soroban.Types.Bool,
        Soroban.Types.Bytes,
        Soroban.Types.Duration,
        Soroban.Types.Int32,
        Soroban.Types.Int64,
        Soroban.Types.Int128,
        Soroban.Types.Int256,
        Soroban.Types.String,
        Soroban.Types.Symbol,
        Soroban.Types.TimePoint,
        Soroban.Types.UInt32,
        Soroban.Types.UInt64,
        Soroban.Types.UInt128,
        Soroban.Types.UInt256,
        Soroban.Types.Vec,
        Soroban.Types.Tuple,
        Soroban.Types.MapEntry,
        Soroban.Types.Map,
        Soroban.Types.Enum,
        Soroban.Types.StructField,
        Soroban.Types.Struct,
        Soroban.Types.Option
      ]
    ]
  end

  defp extras() do
    [
      "README.md",
      "CHANGELOG.md",
      "CONTRIBUTING.md"
    ]
  end
end
