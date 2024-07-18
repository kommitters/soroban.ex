defmodule Soroban.RPC do
  @moduledoc """
  Exposes functions to interact with the Soroban API requests.
  """

  alias Soroban.RPC.{
    GetEvents,
    GetHealth,
    GetLatestLedger,
    GetLedgerEntries,
    GetLedgerEntriesResponse,
    GetNetwork,
    GetTransaction,
    GetTransactions,
    SendTransaction,
    SimulateTransaction
  }

  alias Stellar.TxBuild.LedgerKey
  alias StellarBase.XDR.LedgerKey, as: LedgerKeyXDR
  alias StellarBase.XDR.{AccountEntry, LedgerEntryData, SequenceNumber}

  def fetch_next_sequence_number(server, account_id) do
    {:account, account_id: account_id}
    |> LedgerKey.new()
    |> encode_xdr()
    |> encode_base64()
    |> call_get_ledger_entries(server)
    |> decode_ledger_entry_data()
    |> increment_sequence_number()
  end

  defdelegate send_transaction(server, base64_envelope), to: SendTransaction, as: :request

  defdelegate simulate_transaction(server, args),
    to: SimulateTransaction,
    as: :request

  defdelegate get_transaction(server, hash), to: GetTransaction, as: :request
  defdelegate get_transactions(server, hash), to: GetTransactions, as: :request
  defdelegate get_ledger_entries(server, keys), to: GetLedgerEntries, as: :request
  defdelegate get_events(server, payload), to: GetEvents, as: :request
  defdelegate get_health(server), to: GetHealth, as: :request
  defdelegate get_latest_ledger(server), to: GetLatestLedger, as: :request
  defdelegate get_network(server), to: GetNetwork, as: :request

  defp encode_xdr(%LedgerKey{} = ledger_key) do
    ledger_key
    |> LedgerKey.to_xdr()
    |> LedgerKeyXDR.encode_xdr()
  end

  defp encode_xdr({:error, reason}), do: {:error, reason}

  defp encode_base64({:ok, encode_xdr}), do: {:ok, Base.encode64(encode_xdr)}
  defp encode_base64({:error, reason}), do: {:error, reason}

  defp call_get_ledger_entries({:ok, ledger_key_base64}, server) do
    get_ledger_entries(server, [ledger_key_base64])
  end

  defp call_get_ledger_entries({:error, reason}, _server), do: {:error, reason}

  defp decode_ledger_entry_data(
         {:ok, %GetLedgerEntriesResponse{entries: [%{xdr: ledger_entry_data_xdr}]}}
       ) do
    ledger_entry_data_xdr
    |> Base.decode64!()
    |> LedgerEntryData.decode_xdr()
  end

  defp decode_ledger_entry_data({:ok, %GetLedgerEntriesResponse{entries: []}}) do
    {:error, :account_not_found}
  end

  defp decode_ledger_entry_data({:error, reason}), do: {:error, reason}

  defp increment_sequence_number(
         {:ok,
          {%LedgerEntryData{
             value: %AccountEntry{
               seq_num: %SequenceNumber{sequence_number: seq_num}
             }
           }, ""}}
       ) do
    {:ok, seq_num + 1}
  end

  defp increment_sequence_number({:error, reason}), do: {:error, reason}
end
