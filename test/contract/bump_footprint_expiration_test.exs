defmodule Stellar.Horizon.Client.CannedBumpAccountRequests do
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

defmodule Soroban.RPC.CannedBumpFootprintExpirationClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAZAAAAAAABhqAAAAABAAAAAAAAAAEAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAFAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       transaction_data:
         "AAAAAAAAAAIAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAFAAAAAEAAAAAAAAAB5g18rNSrgYpg/O7tgIlBv42+QqjpEFv6gEqW+oDFUZbAAAAAAAAAAAANYvgAAAUOAAAAAAAAADwAAAAAAAAAC8=",
       events: nil,
       min_resource_fee: "79488",
       results: [
         %{
           auth: nil,
           xdr: "AAAAEAAAAAEAAAACAAAADwAAAAVIZWxsbwAAAAAAAA8AAAAFd29ybGQAAAA="
         }
       ],
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
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAZAAAAAAABhqAAAAABAAAAAAAAAAEAAAAHBn63ukGe3T6UbgjrF6gfvh6FDmkO12khYIdcK2W0XyEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       transaction_data:
         "AAAAAAAAAAIAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAFAAAAAEAAAAAAAAAB5g18rNSrgYpg/O7tgIlBv42+QqjpEFv6gEqW+oDFUZbAAAAAAAAAAAANYvgAAAUOAAAAAAAAADwAAAAAAAAAC8=",
       events: nil,
       min_resource_fee: "79488",
       results: [
         %{
           auth: nil,
           xdr: "AAAAEAAAAAEAAAACAAAADwAAAAVIZWxsbwAAAAAAAA8AAAAFd29ybGQAAAA="
         }
       ],
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
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAZAAAAAAABhqAAAAABAAAAAAAAAAIAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAEAAAAAEAAAABAAAADwAAAANUbXAAAAAAAAAAAAAAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAEAAAAAEAAAABAAAADwAAAANQZXIAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       transaction_data:
         "AAAAAAAAAAIAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAFAAAAAEAAAAAAAAAB5g18rNSrgYpg/O7tgIlBv42+QqjpEFv6gEqW+oDFUZbAAAAAAAAAAAANYvgAAAUOAAAAAAAAADwAAAAAAAAAC8=",
       events: nil,
       min_resource_fee: "79488",
       results: [
         %{
           auth: nil,
           xdr: "AAAAEAAAAAEAAAACAAAADwAAAAVIZWxsbwAAAAAAAA8AAAAFd29ybGQAAAA="
         }
       ],
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

defmodule Soroban.Contract.BumpFootprintExpirationTest do
  use ExUnit.Case

  alias Soroban.Contract.BumpFootprintExpiration

  alias Soroban.RPC.{
    CannedBumpFootprintExpirationClientImpl,
    SendTransactionResponse
  }

  alias Stellar.Horizon.Client.CannedBumpAccountRequests

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedBumpAccountRequests)
    Application.put_env(:soroban, :http_client_impl, CannedBumpFootprintExpirationClientImpl)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{
      contract_address: "CD3HNKU3ERTEYLBBBVTSOYE4ZL2ZWV7NHLQIZRRKC4CBNMZXC7ISBXHV",
      contract_hash: "067eb7ba419edd3e946e08eb17a81fbe1e850e690ed7692160875c2b65b45f21",
      # GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      keys: [{:temporary, "Tmp"}, {:persistent, "Per"}],
      ledgers_to_bump: 100_000
    }
  end

  test "bump_contract/3", %{
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_bump: ledgers_to_bump
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      BumpFootprintExpiration.bump_contract(
        contract_address,
        source_secret,
        ledgers_to_bump
      )
  end

  test "bump_contract/3 with invalid ledger", %{
    contract_address: contract_address,
    source_secret: source_secret
  } do
    {:error, :invalid_ledger_to_bump} =
      BumpFootprintExpiration.bump_contract(
        contract_address,
        source_secret,
        -100_000
      )
  end

  test "bump_contract_wasm/3", %{
    contract_hash: contract_hash,
    source_secret: source_secret,
    ledgers_to_bump: ledgers_to_bump
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      BumpFootprintExpiration.bump_contract_wasm(
        contract_hash,
        source_secret,
        ledgers_to_bump
      )
  end

  test "bump_contract_keys/4", %{
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_bump: ledgers_to_bump,
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
      BumpFootprintExpiration.bump_contract_keys(
        contract_address,
        source_secret,
        ledgers_to_bump,
        keys
      )
  end

  test "bump_contract_keys/4 with invalid keys", %{
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_bump: ledgers_to_bump
  } do
    {:error, :invalid_keys} =
      BumpFootprintExpiration.bump_contract_keys(
        contract_address,
        source_secret,
        ledgers_to_bump,
        :invalid
      )
  end
end
