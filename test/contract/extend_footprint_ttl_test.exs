defmodule Soroban.RPC.CannedExtendFootprintTTLClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(
        "getLedgerEntries",
        _url,
        _headers,
        _body,
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       entries: [
         %{
           key: "AAAAAAAAAAB8VFyuIrnqhGA3aSvFShpwVwYZGwD3Yx5guKZGcn1ofQ==",
           last_modified_ledger_seq: 462_965,
           #  this xdr is a LedgerEntryData of type account with sequence number 1_390_916_568_875_069
           xdr:
             "AAAAAAAAAAB8VFyuIrnqhGA3aSvFShpwVwYZGwD3Yx5guKZGcn1ofQAAABdIdugAAATxCAAAAD0AAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA"
         }
       ],
       latest_ledger: 462_966
     }}
  end

  @impl true
  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAZAAAAAAABhqAAAAABAAAAAAAAAAEAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAFAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       transaction_data:
         "AAAAAAAAAAEAAAAGAAAAAQmM+SjuK6EFG2xjRoNDYSKeKWmaP+sPIZ2z+rHmx5I0AAAAFAAAAAEAAAAAAAAAAAAAAVQAAAAAAAAAAAAAAAA=",
       events: nil,
       min_resource_fee: "79488",
       results: nil,
       cost: %{cpu_insns: "1048713", mem_bytes: "1201148"},
       latest_ledger: 45_075_181
     }}
  end

  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAZAAAAAAABhqAAAAABAAAAAAAAAAEAAAAHBn63ukGe3T6UbgjrF6gfvh6FDmkO12khYIdcK2W0XyEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       transaction_data:
         "AAAAAAAAAAEAAAAGAAAAAQmM+SjuK6EFG2xjRoNDYSKeKWmaP+sPIZ2z+rHmx5I0AAAAFAAAAAEAAAAAAAAAAAAAAVQAAAAAAAAAAAAAAAA=",
       events: nil,
       min_resource_fee: "79488",
       results: nil,
       cost: %{cpu_insns: "1048713", mem_bytes: "1201148"},
       latest_ledger: 45_075_181
     }}
  end

  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAZAAAAAAABhqAAAAABAAAAAAAAAAIAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAEAAAAAEAAAABAAAADwAAAANUbXAAAAAAAAAAAAYAAAAB9naqmyRmTCwhDWcnYJzK9ZtX7TrgjMYqFwQWszcX0SAAAAAQAAAAAQAAAAEAAAAPAAAAA1BlcgAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       transaction_data:
         "AAAAAAAAAAEAAAAGAAAAAQmM+SjuK6EFG2xjRoNDYSKeKWmaP+sPIZ2z+rHmx5I0AAAAFAAAAAEAAAAAAAAAAAAAAVQAAAAAAAAAAAAAAAA=",
       events: nil,
       min_resource_fee: "79488",
       results: nil,
       cost: %{cpu_insns: "1048713", mem_bytes: "1201148"},
       latest_ledger: 45_075_181
     }}
  end

  @impl true
  def request("sendTransaction", _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612"
     }}
  end

  @impl true
  def request("getLatestLedger", _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       id: "08f19981546ea2ef3ea0523a5e4156942f5b34c432b70d51ceb77e6d8e80433c",
       protocol_version: "20",
       sequence: 214_971
     }}
  end
end

defmodule Soroban.Contract.ExtendFootprintTTLTest do
  use ExUnit.Case

  alias Soroban.Contract.ExtendFootprintTTL

  alias Soroban.RPC.{
    CannedExtendFootprintTTLClientImpl,
    SendTransactionResponse,
    Server
  }

  alias Stellar.Network

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedExtendFootprintTTLClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{
      server: Server.testnet(),
      network_passphrase: Network.testnet_passphrase(),
      contract_address: "CD3HNKU3ERTEYLBBBVTSOYE4ZL2ZWV7NHLQIZRRKC4CBNMZXC7ISBXHV",
      wasm_id: "067eb7ba419edd3e946e08eb17a81fbe1e850e690ed7692160875c2b65b45f21",
      # GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      keys: [{:temporary, "Tmp"}, {:persistent, "Per"}],
      ledgers_to_extend: 100_000
    }
  end

  test "extend_contract/5", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_extend: ledgers_to_extend
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      ExtendFootprintTTL.extend_contract(
        server,
        network_passphrase,
        contract_address,
        source_secret,
        ledgers_to_extend
      )
  end

  test "extend_contract/5 with invalid ledger", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_secret: source_secret
  } do
    {:error, :invalid_ledger_to_extend} =
      ExtendFootprintTTL.extend_contract(
        server,
        network_passphrase,
        contract_address,
        source_secret,
        -100_000
      )
  end

  test "extend_contract_wasm/5", %{
    server: server,
    network_passphrase: network_passphrase,
    wasm_id: wasm_id,
    source_secret: source_secret,
    ledgers_to_extend: ledgers_to_extend
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      ExtendFootprintTTL.extend_contract_wasm(
        server,
        network_passphrase,
        wasm_id,
        source_secret,
        ledgers_to_extend
      )
  end

  test "extend_contract_keys/6", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_extend: ledgers_to_extend,
    keys: keys
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      ExtendFootprintTTL.extend_contract_keys(
        server,
        network_passphrase,
        contract_address,
        source_secret,
        ledgers_to_extend,
        keys
      )
  end

  test "extend_contract_keys/6 with invalid keys", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_extend: ledgers_to_extend
  } do
    {:error, :invalid_keys} =
      ExtendFootprintTTL.extend_contract_keys(
        server,
        network_passphrase,
        contract_address,
        source_secret,
        ledgers_to_extend,
        :invalid
      )
  end
end
