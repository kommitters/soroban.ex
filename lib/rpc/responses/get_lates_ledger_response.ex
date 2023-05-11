defmodule Soroban.RPC.GetLatestLedgerResponse do
  @moduledoc """
  `GetLatestLedgerResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type hash :: String.t()
  @type protocol_version :: non_neg_integer()
  @type sequence :: non_neg_integer()
  @type t :: %__MODULE__{
          id: hash(),
          protocol_version: protocol_version(),
          sequence: sequence()
        }

  defstruct [:id, :protocol_version, :sequence]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
