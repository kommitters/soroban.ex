defmodule Soroban.RPC.GetVersionInfoResponse do
  @moduledoc """
  `GetVersionInfoResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type version :: String.t()
  @type commit_hash :: String.t()
  @type build_time_stamp :: String.t()
  @type captive_core_version :: String.t()
  @type protocol_version :: non_neg_integer()
  @type t :: %__MODULE__{
          version: version(),
          commit_hash: commit_hash(),
          build_time_stamp: build_time_stamp(),
          captive_core_version: captive_core_version(),
          protocol_version: protocol_version()
        }

  defstruct [:version, :commit_hash, :build_time_stamp, :captive_core_version, :protocol_version]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
