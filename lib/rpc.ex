defmodule Soroban.RPC do
  @moduledoc """
  Exposes functions to interact with the Soroban API requests.
  """

  alias Soroban.RPC.{
    GetHealth,
    GetLatestLedger,
    GetLedgerEntry,
    GetNetwork,
    GetTransaction,
    SendTransaction,
    SimulateTransaction
  }

  defdelegate send_transaction(base64_envelope), to: SendTransaction, as: :request
  defdelegate simulate_transaction(base64_envelope), to: SimulateTransaction, as: :request
  defdelegate get_transaction(hash), to: GetTransaction, as: :request
  defdelegate get_ledger_entry(key), to: GetLedgerEntry, as: :request
  defdelegate get_health(), to: GetHealth, as: :request
  defdelegate get_latest_ledger(), to: GetLatestLedger, as: :request
  defdelegate get_network(), to: GetNetwork, as: :request
end
