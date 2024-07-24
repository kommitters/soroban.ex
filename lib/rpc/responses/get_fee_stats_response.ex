defmodule Soroban.RPC.GetFeeStatsResponse do
  @moduledoc """
  `GetFeeStatsResponse` struct definition.
  """

  @behaviour Soroban.RPC.Response.Spec

  @type soroban_inclusion_fee :: map()
  @type inclusion_fee :: map()
  @type latest_ledger :: non_neg_integer()

  defstruct [:soroban_inclusion_fee, :inclusion_fee, :latest_ledger]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
