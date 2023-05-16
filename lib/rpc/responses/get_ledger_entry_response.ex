defmodule Soroban.RPC.GetLedgerEntryResponse do
  @moduledoc """
  `GetLedgerEntryResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type xdr :: String.t()
  @type last_modified_ledger_seq :: String.t()
  @type latest_ledger :: String.t()
  @type t :: %__MODULE__{
          xdr: xdr(),
          last_modified_ledger_seq: last_modified_ledger_seq(),
          latest_ledger: latest_ledger()
        }

  defstruct [:xdr, :last_modified_ledger_seq, :latest_ledger]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
