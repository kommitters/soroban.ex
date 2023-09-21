defmodule Stellar.Horizon.Client.CannedDeployAccountRequests do
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

defmodule Soroban.RPC.CannedDeployInvokeHostFunctionClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

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
           auth: [
             "AAAAAAAAAAEAAAAAAAAAAAAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2hnv5IMztuFIUbDO484C3+P3zeMpMPFbUnPrAKdNylWQAAAAALqFcJIqu7BU+fusD3nFiAt81t0l8w2nLY4zDfVVDc0CAAAAAA=="
           ],
           xdr: "AAAAEgAAAAELFUNtokcHcbdBj+wofK950nXGsv492Q1LCJ9tQo9GkA=="
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
       hash: "308f5f3c7b2c0a690e7e19b6d14c22af87763f5ae483d6d1af43b9639732d206",
       latest_ledger: "602691",
       latest_ledger_close_time: "1683814245"
     }}
  end
end

defmodule Soroban.Contract.DeployContractTest do
  use ExUnit.Case

  alias Soroban.Contract.DeployContract

  alias Soroban.RPC.{
    CannedDeployInvokeHostFunctionClientImpl,
    SendTransactionResponse
  }

  alias Stellar.Horizon.Client.CannedDeployAccountRequests

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedDeployAccountRequests)
    Application.put_env(:soroban, :http_client_impl, CannedDeployInvokeHostFunctionClientImpl)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{
      source_public: "GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3",
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      source_public_with_error: "GASY52GNGVKEMXSGH7VSCZQKRWQMIQD77J53KHXEBAV2BODWH6FDDZ3F",
      source_secret_with_error: "SDXKY6TSBNS7T2UJMHLIH4BWTP4EHR52HZTRNEKH33ML3ARJI2AKIPEC",
      wasm_id:
        <<186, 133, 112, 146, 42, 187, 176, 84, 249, 251, 172, 15, 121, 197, 136, 11, 124, 214,
          221, 37, 243, 13, 167, 45, 142, 51, 13, 245, 85, 13, 205, 2>>
    }
  end

  test "deploy/2", %{
    wasm_id: wasm_id,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "308f5f3c7b2c0a690e7e19b6d14c22af87763f5ae483d6d1af43b9639732d206",
       latest_ledger: "602691",
       latest_ledger_close_time: "1683814245",
       error_result_xdr: nil
     }} = DeployContract.deploy(wasm_id, source_secret)
  end

  test "retrieve_unsigned_xdr_to_deploy/2", %{
    wasm_id: wasm_id,
    source_public_with_error: source_public
  } do
    assert String.contains?(
             DeployContract.retrieve_unsigned_xdr_to_deploy(
               wasm_id,
               source_public
             ),
             "AAAAAgAAAAAlj"
           )
  end
end
