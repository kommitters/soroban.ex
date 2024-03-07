defmodule Soroban.RPC.Server do
  @moduledoc """
  Soroban RPC Server configuration.
  """

  defstruct [:url]

  @type t :: %__MODULE__{url: String.t()}

  @spec new(url :: String.t()) :: t()
  def new(url) when is_binary(url), do: %__MODULE__{url: url}

  @spec testnet() :: t()
  def testnet, do: new("https://soroban-testnet.stellar.org")

  @spec futurenet() :: t()
  def futurenet, do: new("https://rpc-futurenet.stellar.org")

  @spec local() :: t()
  def local, do: new("http://localhost:8000")
end
