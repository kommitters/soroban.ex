defmodule Soroban.RPC.GetLedgerEntriesResponse do
  @moduledoc """
  `GetLedgerEntriesResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type entries :: list(map())
  @type latest_ledger :: non_neg_integer()
  @type t :: %__MODULE__{
          entries: entries(),
          latest_ledger: latest_ledger()
        }

  defstruct [:entries, :latest_ledger]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
