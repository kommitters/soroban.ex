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
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAQAAAAIAAAAyAGFzbQEAAAABQQxgAX4BfmACfn4BfmADfn5+AX5gAAF+YAR+fn5+AX5gAX4Bf2ACf34AAAAAAAAAAAAAAAAAAA=="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       transaction_data:
         "AAAAAwAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcAAAAG4avr0cYyEk0etiaStUgJ889XGSqUqZEZcCyR+ma87LIAAAAUAAAAB8zDhJ3ZTMHmdBjlVh/7d1HDdo+QI1ZXGmeRzBwVAoVXAAAAAQAAAAbhq+vRxjISTR62JpK1SAnzz1cZKpSpkRlwLJH6ZrzssgAAABUAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3ACb/vgAAFcQAAAC0AAABrAAAAAAAAABUAAAAAA==",
       events: nil,
       min_resource_fee: "79488",
       results: [
         %{
           auth: nil,
           events: nil,
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
            "AAAAAgAAAAAljujNNVRGXkY/6yFmCo2gxEB/+nu1HuQIK6C4dj+KMQAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAQAAAAIAAAAyAGFzbQEAAAABQQxgAX4BfmACfn4BfmADfn5+AX5gAAF+YAR+fn5+AX5gAX4Bf2ACf34AAAAAAAAAAAAAAAAAAA=="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       error: "error",
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
       hash: "308f5f3c7b2c0a690e7e19b6d14c22af87763f5ae483d6d1af43b9639732d206",
       latest_ledger: "602691",
       latest_ledger_close_time: "1683814245"
     }}
  end
end

defmodule Soroban.Contract.UploadContractCodeTest do
  use ExUnit.Case

  alias Soroban.Contract.UploadContractCode

  alias Soroban.RPC.{
    CannedUploadInvokeHostFunctionClientImpl,
    GetTransactionResponse,
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

    transaction_response =
      {:ok,
       %GetTransactionResponse{
         status: "SUCCESS",
         latest_ledger: "150887",
         latest_ledger_close_time: "1685741803",
         oldest_ledger: "149448",
         oldest_ledger_close_time: "1685734263",
         ledger: "150876",
         created_at: "1685741744",
         application_order: 1,
         fee_bump: nil,
         envelope_xdr:
           "AAAAAgAAAADJTnjlYcJxSKDat78jbEyDkVqo2uhpNX4BdBtqGrx+1gAAIcwAAHZZAAAABAAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAQAAAAIAAAHuAGFzbQEAAAABFwVgAX4BfmACfn4BfmAAAX5gAX8AYAAAAhMDAWwBMAAAAWwBMQAAAWwBXwABAwYFAgMEBAQFAwEAEAYZA38BQYCAwAALfwBBgIDAAAt/AEGAgMAACwc1BQZtZW1vcnkCAAlpbmNyZW1lbnQAAwFfAAcKX19kYXRhX2VuZAMBC19faGVhcF9iYXNlAwIKwQEFogEDAX8BfgF/I4CAgIAAQRBrIgAkgICAgAACQAJAQo660K+G1DkQgICAgABCAVINAAJAQo660K+G1DkQgYCAgAAiAUL/AYNCBFINACABQiCIpyECDAILIABBCGoQhICAgAAAC0EAIQILAkAgAkEBaiICDQAQhYCAgAAAC0KOutCvhtQ5IAKtQiCGQgSEIgEQgoCAgAAaIABBEGokgICAgAAgAQsJABCGgICAAAALCQAQhoCAgAAACwQAAAALAgALAB4RY29udHJhY3RlbnZtZXRhdjAAAAAAAAAAFAAAACUAcw5jb250cmFjdHNwZWN2MAAAAAAAAABASW5jcmVtZW50IGluY3JlbWVudHMgYW4gaW50ZXJuYWwgY291bnRlciwgYW5kIHJldHVybnMgdGhlIHZhbHVlLgAAAAlpbmNyZW1lbnQAAAAAAAAAAAAAAQAAAAQAAAAAAAAAAAABAAAAAQAAAAe7u0W71jGn1HRVU31RHkxALif4ynfRG6iiRh4VcL5wGgAAAAAAAUBLAAACSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARq8ftYAAABAs7/r88nugRA0s6jA3GKHdf5w/xJ3H91p6Pe6u0ilL1VbWU52TUaMjvcC3cBCEgcAZeA9hHIBYlql+LssEMMiDg==",
         result_xdr:
           "AAAAAAAAHrsAAAAAAAAAAQAAAAAAAAAYAAAAAAAAAAEAAAANAAAAILu7RbvWMafUdFVTfVEeTEAuJ/jKd9EbqKJGHhVwvnAaAAAAAA==",
         result_meta_xdr:
           "AAAAAwAAAAIAAAADAAJNXAAAAAAAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYAAAAXSHJWBwAAdlkAAAADAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAwAAAAAAAkx2AAAAAGR6W/wAAAAAAAAAAQACTVwAAAAAAAAAAMlOeOVhwnFIoNq3vyNsTIORWqja6Gk1fgF0G2oavH7WAAAAF0hyVgcAAHZZAAAABAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAAJNXAAAAABkemCwAAAAAAAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAAAAAHrsAAAAAAAAAAQAAAAAAAAAYAAAAAAAAAAEAAAANAAAAILu7RbvWMafUdFVTfVEeTEAuJ/jKd9EbqKJGHhVwvnAaAAAAAN90iklmZSDDnZuZvr0/1jhza3d9dtfkgBfeEkm+vX2Sy7xIdQ3ruFNQk7Per4isf0z/h0JVdqWN4rrHVKzbRhZW2KridVIWKh42JsM+5lLygOlqaAz8gb0ixXmNmUfIcQAAAAA="
       }}

    %{
      contract_id: "be4138b31cc5d0d9d91b53193d74316d254406794ec0f81d3ed40f4dc1b86a6e",
      source_public: "GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3",
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      source_public_with_error: "GASY52GNGVKEMXSGH7VSCZQKRWQMIQD77J53KHXEBAV2BODWH6FDDZ3F",
      source_secret_with_error: "SDXKY6TSBNS7T2UJMHLIH4BWTP4EHR52HZTRNEKH33ML3ARJI2AKIPEC",
      wasm:
        <<0, 97, 115, 109, 1, 0, 0, 0, 1, 65, 12, 96, 1, 126, 1, 126, 96, 2, 126, 126, 1, 126, 96,
          3, 126, 126, 126, 1, 126, 96, 0, 1, 126, 96, 4, 126, 126, 126, 126, 1, 126, 96, 1, 126,
          1, 127, 96, 2, 127, 126>>,
      transaction_response: transaction_response,
      envelope_xdr:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAQAAAAIAAAAyAGFzbQEAAAABQQxgAX4BfmACfn4BfmADfn5+AX5gAAF+YAR+fn5+AX5gAX4Bf2ACf34AAAAAAAAAAAAAAAAAAA=="
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
       latest_ledger: "602691",
       latest_ledger_close_time: "1683814245",
       error_result_xdr: nil
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

  test "get_wasm_id/1", %{
    transaction_response: transaction_response
  } do
    <<187, 187, 69, 187, 214, 49, 167, 212, 116, 85, 83, 125, 81, 30, 76, 64, 46, 39, 248, 202,
      119, 209, 27, 168, 162, 70, 30, 21, 112, 190, 112,
      26>> = UploadContractCode.get_wasm_id(transaction_response)
  end
end
