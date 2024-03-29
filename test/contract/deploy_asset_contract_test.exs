defmodule Soroban.RPC.CannedDeployAssetInvokeHostFunctionClientImpl do
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
        _body,
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       transaction_data:
         "AAAAAAAAAAIAAAAGAAAAAQmM+SjuK6EFG2xjRoNDYSKeKWmaP+sPIZ2z+rHmx5I0AAAAFAAAAAEAAAAHjDfZjX1lF+yHF4743DgE1KQTRmGJtwRYh3hJXOzQ9k8AAAAAAE74MAAAGPAAAAAAAAAAAAAAAA0=",
       events: nil,
       min_resource_fee: "79488",
       results: [
         %{
           auth: nil,
           xdr: "AAAAEgAAAAHLxj0ezU9LuP51sP0cgj3NjAdlChTibqzhZENiHNCSEQ=="
         }
       ],
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
       hash: "308f5f3c7b2c0a690e7e19b6d14c22af87763f5ae483d6d1af43b9639732d206",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683814245"
     }}
  end
end

defmodule Soroban.Contract.DeployAssetContractTest do
  use ExUnit.Case

  alias Soroban.Contract.DeployAssetContract

  alias Soroban.RPC.{
    CannedDeployAssetInvokeHostFunctionClientImpl,
    SendTransactionResponse,
    Server
  }

  alias Stellar.Network

  setup do
    Application.put_env(
      :soroban,
      :http_client_impl,
      CannedDeployAssetInvokeHostFunctionClientImpl
    )

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{
      server: Server.testnet(),
      network_passphrase: Network.testnet_passphrase(),
      source_public: "GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3",
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      asset_issuer: "GB2LNFAIQWPJPMLQRDRD7FFY5VIJUBCZIQBWRR2L3RSOVWGH3T5Z56SN",
      asset_code: "ZZZ",
      envelope_xdr:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gABNuQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAQAAAAEAAAABWlpaAAAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAAEAAAAAAAAAAQAAAAAAAAACAAAABgAAAAEJjPko7iuhBRtsY0aDQ2Einilpmj/rDyGds/qx5seSNAAAABQAAAABAAAAB4w32Y19ZRfshxeO+Nw4BNSkE0ZhibcEWId4SVzs0PZPAAAAAABO+DAAABjwAAAAAAAAAAAAAAANAAAAAA=="
    }
  end

  test "deploy/4", %{
    server: server,
    network_passphrase: network_passphrase,
    asset_code: asset_code,
    source_public: source_public,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "308f5f3c7b2c0a690e7e19b6d14c22af87763f5ae483d6d1af43b9639732d206",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683814245",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      DeployAssetContract.deploy(
        server,
        network_passphrase,
        asset_code,
        source_public,
        source_secret
      )
  end

  test "deploy/4 with a different invoker than the issuer of the asset", %{
    server: server,
    network_passphrase: network_passphrase,
    asset_code: asset_code,
    asset_issuer: asset_issuer,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "308f5f3c7b2c0a690e7e19b6d14c22af87763f5ae483d6d1af43b9639732d206",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683814245",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      DeployAssetContract.deploy(
        server,
        network_passphrase,
        asset_code,
        asset_issuer,
        source_secret
      )
  end

  test "retrieve_unsigned_xdr_to_deploy_asset/4", %{
    server: server,
    network_passphrase: network_passphrase,
    asset_code: asset_code,
    source_public: source_public,
    envelope_xdr: envelope_xdr
  } do
    ^envelope_xdr =
      DeployAssetContract.retrieve_unsigned_xdr_to_deploy_asset(
        server,
        network_passphrase,
        asset_code,
        source_public
      )
  end
end
