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
       results: [
         %{
           auth: nil,
           events: nil,
           footprint:
             "AAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAA",
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
    GetTransactionResponse,
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

    transaction_response =
      {:ok,
       %GetTransactionResponse{
         status: "SUCCESS",
         latest_ledger: "603234",
         latest_ledger_close_time: "1683817110",
         oldest_ledger: "601795",
         oldest_ledger_close_time: "1683809524",
         ledger: "603232",
         created_at: "1683817100",
         application_order: 1,
         fee_bump: nil,
         envelope_xdr:
           "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQAADg8AAAANQAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAQAAAABPhblqO4w5ACZfmr2kwFKvP5Mb/BAnopQJ/l8Did9yfgAAAABC0CMoUj8YPgChW8guZS0Y2IyCqf7ZC4MtCZcFwrzNGgAAAAEAAAAHQtAjKFI/GD4AoVvILmUtGNiMgqn+2QuDLQmXBcK8zRoAAAABAAAABuHgM9/NXxKyb+WAHp6V2h6BRRNKtDX/2xSiU2o86ybGAAAAFAAAAAAAAAAAAAAAAcFisdoAAABAcga8HCpn8qTjhLKJWIH8F1Uul5qDJtIRJ8zzg+fSHmMi4yGYP0SGx3bFwJ9TmfTvhoehaGEtZjHs31M53exQCA==",
         result_xdr:
           "AAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAYAAAAAAAAAA0AAAAg4eAz381fErJv5YAenpXaHoFFE0q0Nf/bFKJTajzrJsYAAAAA",
         result_meta_xdr:
           "AAAAAwAAAAIAAAADAAk0YAAAAAAAAAAAWjshnxvxlOorTtBJXCh3BalUvn2zeWxrcNMgwsFisdoAAAAXSHbTTAAAODwAAAA0AAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAwAAAAAACTJfAAAAAGRc9/UAAAAAAAAAAQAJNGAAAAAAAAAAAFo7IZ8b8ZTqK07QSVwodwWpVL59s3lsa3DTIMLBYrHaAAAAF0h200wAADg8AAAANQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAAk0YAAAAABkXQKMAAAAAAAAAAEAAAABAAAAAAAJNGAAAAAG4eAz381fErJv5YAenpXaHoFFE0q0Nf/bFKJTajzrJsYAAAAUAAAAEgAAAABC0CMoUj8YPgChW8guZS0Y2IyCqf7ZC4MtCZcFwrzNGgAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAZAAAAAAAAAABAAAAAAAAABgAAAAAAAAADQAAACDh4DPfzV8Ssm/lgB6eldoegUUTSrQ1/9sUolNqPOsmxgAAAABPZGsJLcZJlHoaEWJ5SKbTmIcEL+Ct4KL2hwWUYB6Jicu8SHUN67hTUJOz3q+IrH9M/4dCVXaljeK6x1Ss20YWjFAcFfqzDNYg+WSRSa0CERreUtqnuy/RAKWBr3NXpbgAAAAA"
       }}

    %{
      contract_id: "be4138b31cc5d0d9d91b53193d74316d254406794ec0f81d3ed40f4dc1b86a6e",
      source_public: "GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3",
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      source_public_with_error: "GASY52GNGVKEMXSGH7VSCZQKRWQMIQD77J53KHXEBAV2BODWH6FDDZ3F",
      source_secret_with_error: "SDXKY6TSBNS7T2UJMHLIH4BWTP4EHR52HZTRNEKH33ML3ARJI2AKIPEC",
      wasm_id:
        <<66, 208, 35, 40, 82, 63, 24, 62, 0, 161, 91, 200, 46, 101, 45, 24, 216, 140, 130, 169,
          254, 217, 11, 131, 45, 9, 151, 5, 194, 188, 205, 26>>,
      transaction_response: transaction_response
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

  test "retrieve_xdr_to_sign/2", %{
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

  test "get_contract_id/1", %{
    transaction_response: transaction_response
  } do
    "e1e033dfcd5f12b26fe5801e9e95da1e8145134ab435ffdb14a2536a3ceb26c6" =
      DeployContract.get_contract_id(transaction_response)
  end
end
