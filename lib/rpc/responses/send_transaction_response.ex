defmodule Soroban.RPC.SendTransactionResponse do
  @moduledoc """
  `SendTransactionResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type status :: String.t()
  @type hash :: binary()
  @type latest_ledger :: non_neg_integer()
  @type latest_ledger_close_time :: String.t()
  @type error_result_xdr :: String.t() | nil
  @type t :: %__MODULE__{
          status: status(),
          hash: hash(),
          latest_ledger: latest_ledger(),
          latest_ledger_close_time: latest_ledger_close_time(),
          error_result_xdr: error_result_xdr()
        }

  defstruct [:status, :hash, :latest_ledger, :latest_ledger_close_time, :error_result_xdr]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
