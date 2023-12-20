defmodule Soroban.RPC.GetTransactionResponse do
  @moduledoc """
  `GetTransactionResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type status :: String.t()
  @type latest_ledger :: non_neg_integer()
  @type latest_ledger_close_time :: String.t()
  @type oldest_ledger :: non_neg_integer()
  @type oldest_ledger_close_time :: String.t()
  @type ledger :: non_neg_integer() | nil
  @type created_at :: String.t() | nil
  @type application_order :: number() | nil
  @type fee_bump :: boolean() | nil
  @type envelope_xdr :: String.t() | nil
  @type result_xdr :: String.t() | nil
  @type result_meta_xdr :: String.t() | nil
  @type t :: %__MODULE__{
          status: status(),
          latest_ledger: latest_ledger(),
          latest_ledger_close_time: latest_ledger_close_time(),
          oldest_ledger: oldest_ledger(),
          oldest_ledger_close_time: oldest_ledger_close_time(),
          ledger: ledger(),
          created_at: created_at(),
          application_order: application_order(),
          fee_bump: fee_bump(),
          envelope_xdr: envelope_xdr(),
          result_xdr: result_xdr(),
          result_meta_xdr: result_meta_xdr()
        }

  defstruct [
    :status,
    :latest_ledger,
    :latest_ledger_close_time,
    :oldest_ledger,
    :oldest_ledger_close_time,
    :ledger,
    :created_at,
    :application_order,
    :fee_bump,
    :envelope_xdr,
    :result_xdr,
    :result_meta_xdr
  ]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
