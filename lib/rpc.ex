defmodule Soroban.RPC do
  @moduledoc """
  Exposes functions to interact with the Soroban API requests.
  """

  alias Soroban.RPC.{
    GetEvents,
    GetHealth,
    GetLatestLedger,
    GetLedgerEntries,
    GetNetwork,
    GetTransaction,
    SendTransaction,
    SimulateTransaction
  }

  defdelegate send_transaction(server, base64_envelope), to: SendTransaction, as: :request

  defdelegate simulate_transaction(server, base64_envelope, addl_resources \\ []),
    to: SimulateTransaction,
    as: :request

  defdelegate get_transaction(server, hash), to: GetTransaction, as: :request
  defdelegate get_ledger_entries(server, keys), to: GetLedgerEntries, as: :request
  defdelegate get_events(server, payload), to: GetEvents, as: :request
  defdelegate get_health(server), to: GetHealth, as: :request
  defdelegate get_latest_ledger(server), to: GetLatestLedger, as: :request
  defdelegate get_network(server), to: GetNetwork, as: :request
end
