defmodule Stellar.Horizon.Client.CannedExtendAccountRequests do
  @moduledoc false

  @base_url "https://horizon-testnet.stellar.org"

  def request(
        :get,
        @base_url <> "/accounts/GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3",
        _headers,
        _body,
        _opts
      ) do
    {:ok, 200, [], "{\"sequence\":\"1390916568875069\"}"}
  end
end

defmodule Soroban.RPC.CannedExtendFootprintTTLClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

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
       latest_ledger: "475528"
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
       latest_ledger: "475528"
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
       latest_ledger: "475528"
     }}
  end

  @impl true
  def request("sendTransaction", _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
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
    SendTransactionResponse
  }

  alias Stellar.Horizon.Client.CannedExtendAccountRequests

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedExtendAccountRequests)
    Application.put_env(:soroban, :http_client_impl, CannedExtendFootprintTTLClientImpl)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{
      contract_address: "CD3HNKU3ERTEYLBBBVTSOYE4ZL2ZWV7NHLQIZRRKC4CBNMZXC7ISBXHV",
      wasm_id: "067eb7ba419edd3e946e08eb17a81fbe1e850e690ed7692160875c2b65b45f21",
      # GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      keys: [{:temporary, "Tmp"}, {:persistent, "Per"}],
      ledgers_to_extend: 100_000
    }
  end

  test "extend_contract/3", %{
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_extend: ledgers_to_extend
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      ExtendFootprintTTL.extend_contract(
        contract_address,
        source_secret,
        ledgers_to_extend
      )
  end

  test "extend_contract/3 with invalid ledger", %{
    contract_address: contract_address,
    source_secret: source_secret
  } do
    {:error, :invalid_ledger_to_extend} =
      ExtendFootprintTTL.extend_contract(
        contract_address,
        source_secret,
        -100_000
      )
  end

  test "extend_contract_wasm/3", %{
    wasm_id: wasm_id,
    source_secret: source_secret,
    ledgers_to_extend: ledgers_to_extend
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      ExtendFootprintTTL.extend_contract_wasm(
        wasm_id,
        source_secret,
        ledgers_to_extend
      )
  end

  test "extend_contract_keys/4", %{
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_extend: ledgers_to_extend,
    keys: keys
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      ExtendFootprintTTL.extend_contract_keys(
        contract_address,
        source_secret,
        ledgers_to_extend,
        keys
      )
  end

  test "extend_contract_keys/4 with invalid keys", %{
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_extend: ledgers_to_extend
  } do
    {:error, :invalid_keys} =
      ExtendFootprintTTL.extend_contract_keys(
        contract_address,
        source_secret,
        ledgers_to_extend,
        :invalid
      )
  end
end
