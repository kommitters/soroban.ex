defmodule Soroban.RPC.GetHealthResponse do
  @moduledoc """
  `GetHealthResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type status :: String.t()
  @type latest_ledger :: non_neg_integer()
  @type oldest_ledger :: non_neg_integer()
  @type ledger_retention_window :: non_neg_integer()

  @type t :: %__MODULE__{
          status: status(),
          latest_ledger: latest_ledger(),
          oldest_ledger: oldest_ledger(),
          ledger_retention_window: ledger_retention_window()
        }

  defstruct [:status, :latest_ledger, :oldest_ledger, :ledger_retention_window]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
