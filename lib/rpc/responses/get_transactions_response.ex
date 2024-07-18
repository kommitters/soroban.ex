defmodule Soroban.RPC.GetTransactionsResponse do
  @moduledoc """
  `GetTransactionsResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type transactions :: list(map())
  @type latest_ledger :: non_neg_integer()
  @type latest_ledger_close_time :: String.t()
  @type oldest_ledger :: non_neg_integer()
  @type oldest_ledger_close_time :: String.t()
  @type t :: %__MODULE__{
          latest_ledger: latest_ledger(),
          latest_ledger_close_time: latest_ledger_close_time(),
          oldest_ledger: oldest_ledger(),
          oldest_ledger_close_time: oldest_ledger_close_time(),
          transactions: transactions()
        }

  defstruct [
    :transactions,
    :latest_ledger,
    :latest_ledger_close_time,
    :oldest_ledger,
    :oldest_ledger_close_time
  ]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
