defmodule Stellar.Horizon.Client.CannedUploadAccountRequests do
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

  def request(
        :get,
        @base_url <> "/accounts/GASY52GNGVKEMXSGH7VSCZQKRWQMIQD77J53KHXEBAV2BODWH6FDDZ3F",
        _headers,
        _body,
        _opts
      ) do
    {:ok, 200, [], "{\"sequence\":\"1390916568875069\"}"}
  end
end

defmodule Soroban.RPC.CannedUploadInvokeHostFunctionClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAgAAADAAYXNtAQAAAAEWBGACfn4BfmAEfn5+fgF+YAABfmAAAAITAwFsATAAAAFsATEAAAEAAAAAAAAAAAAAAAA="
        },
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
           events: nil,
           xdr: "AAAADQAAACC6hXCSKruwVPn7rA95xYgLfNbdJfMNpy2OMw31VQ3NAg=="
         }
       ],
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
            "AAAAAgAAAAAljujNNVRGXkY/6yFmCo2gxEB/+nu1HuQIK6C4dj+KMQAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAgAAADAAYXNtAQAAAAEWBGACfn4BfmAEfn5+fgF+YAABfmAAAAITAwFsATAAAAFsATEAAAEAAAAAAAAAAAAAAAA="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       error: "error",
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

defmodule Soroban.Contract.UploadContractCodeTest do
  use ExUnit.Case

  alias Soroban.Contract.UploadContractCode

  alias Soroban.RPC.{
    CannedUploadInvokeHostFunctionClientImpl,
    SendTransactionResponse,
    SimulateTransactionResponse
  }

  alias Stellar.Horizon.Client.CannedUploadAccountRequests

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedUploadAccountRequests)
    Application.put_env(:soroban, :http_client_impl, CannedUploadInvokeHostFunctionClientImpl)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{
      source_public: "GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3",
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      source_public_with_error: "GASY52GNGVKEMXSGH7VSCZQKRWQMIQD77J53KHXEBAV2BODWH6FDDZ3F",
      source_secret_with_error: "SDXKY6TSBNS7T2UJMHLIH4BWTP4EHR52HZTRNEKH33ML3ARJI2AKIPEC",
      wasm:
        <<0, 97, 115, 109, 1, 0, 0, 0, 1, 22, 4, 96, 2, 126, 126, 1, 126, 96, 4, 126, 126, 126,
          126, 1, 126, 96, 0, 1, 126, 96, 0, 0, 2, 19, 3, 1, 108, 1, 48, 0, 0, 1, 108, 1, 49, 0,
          0, 1>>,
      envelope_xdr:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gABNuQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAgAAADAAYXNtAQAAAAEWBGACfn4BfmAEfn5+fgF+YAABfmAAAAITAwFsATAAAAFsATEAAAEAAAAAAAAAAQAAAAAAAAACAAAABgAAAAEJjPko7iuhBRtsY0aDQ2Einilpmj/rDyGds/qx5seSNAAAABQAAAABAAAAB4w32Y19ZRfshxeO+Nw4BNSkE0ZhibcEWId4SVzs0PZPAAAAAABO+DAAABjwAAAAAAAAAAAAAAANAAAAAA=="
    }
  end

  test "upload/2", %{
    wasm: wasm,
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
     }} = UploadContractCode.upload(wasm, source_secret)
  end

  test "upload contract with simulate error", %{
    wasm: wasm,
    source_secret_with_error: source_secret_with_error
  } do
    {:ok,
     %SimulateTransactionResponse{
       error: "error"
     }} =
      UploadContractCode.upload(
        wasm,
        source_secret_with_error
      )
  end

  test "retrieve_unsigned_xdr_to_upload/2", %{
    wasm: wasm,
    source_public: source_public,
    envelope_xdr: envelope_xdr
  } do
    ^envelope_xdr = UploadContractCode.retrieve_unsigned_xdr_to_upload(wasm, source_public)
  end

  test "retrieve_unsigned_xdr_to_upload contract with simulate error", %{
    wasm: wasm,
    source_public_with_error: source_public_with_error
  } do
    {:ok,
     %SimulateTransactionResponse{
       error: "error"
     }} =
      UploadContractCode.retrieve_unsigned_xdr_to_upload(
        wasm,
        source_public_with_error
      )
  end
end
