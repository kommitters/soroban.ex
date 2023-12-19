defmodule Soroban.RPC.GetNetworkResponse do
  @moduledoc """
  `GetNetworkResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type friendbot_url :: String.t()
  @type passphrase :: String.t()
  @type protocol_version :: non_neg_integer()
  @type t :: %__MODULE__{
          friendbot_url: friendbot_url(),
          passphrase: passphrase(),
          protocol_version: protocol_version()
        }

  defstruct [:friendbot_url, :passphrase, :protocol_version]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
