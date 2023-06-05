defmodule Stellar.Horizon.Client.CannedDeployAssetAccountRequests do
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

defmodule Soroban.RPC.CannedDeployAssetInvokeHostFunctionClientImpl do
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
         "AAAAAwAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcAAAAG4avr0cYyEk0etiaStUgJ889XGSqUqZEZcCyR+ma87LIAAAAUAAAAB8zDhJ3ZTMHmdBjlVh/7d1HDdo+QI1ZXGmeRzBwVAoVXAAAAAQAAAAbhq+vRxjISTR62JpK1SAnzz1cZKpSpkRlwLJH6ZrzssgAAABUAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3ACb/vgAAFcQAAAC0AAABrAAAAAAAAABUAAAAAA==",
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
       hash: "308f5f3c7b2c0a690e7e19b6d14c22af87763f5ae483d6d1af43b9639732d206",
       latest_ledger: "602691",
       latest_ledger_close_time: "1683814245"
     }}
  end
end

defmodule Soroban.Contract.DeployAssetContractTest do
  use ExUnit.Case

  alias Soroban.Contract.DeployAssetContract

  alias Soroban.RPC.{
    CannedDeployAssetInvokeHostFunctionClientImpl,
    GetTransactionResponse,
    SendTransactionResponse
  }

  alias Stellar.Horizon.Client.CannedDeployAssetAccountRequests

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedDeployAssetAccountRequests)

    Application.put_env(
      :soroban,
      :http_client_impl,
      CannedDeployAssetInvokeHostFunctionClientImpl
    )

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
      Application.delete_env(:soroban, :http_client_impl)
    end)

    transaction_response =
      {:ok,
       %GetTransactionResponse{
         status: "SUCCESS",
         latest_ledger: "150946",
         latest_ledger_close_time: "1685742107",
         oldest_ledger: "149507",
         oldest_ledger_close_time: "1685734568",
         ledger: "150944",
         created_at: "1685742097",
         application_order: 1,
         fee_bump: nil,
         envelope_xdr:
           "AAAAAgAAAADJTnjlYcJxSKDat78jbEyDkVqo2uhpNX4BdBtqGrx+1gAAlawAAHZZAAAABQAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAQAAAAEAAAAAALoyVImX+BA9hnzcvjZB15srwetgXJatUEh9ZocODPIAAAAAu7tFu9Yxp9R0VVN9UR5MQC4n+Mp30RuookYeFXC+cBoAAAAAAAAAAQAAAAEAAAAHu7tFu9Yxp9R0VVN9UR5MQC4n+Mp30RuookYeFXC+cBoAAAABAAAABpH1zoYhpCfbiSVl8I4zaiIxRArMi/njt4Kv8B4yRHwZAAAAFAABQosAAAJwAAAAgAAAAKgAAAAAAAAAIQAAAAAAAAABGrx+1gAAAEAHFP8VSnrsm31ys5NM6XUmwiI5B2jyanvc61bZogwlOpSzsmhBZ7H/KivYWMkFYVfuWz/8d8bI4gnnhhU794MK",
         result_xdr:
           "AAAAAAAAkxEAAAAAAAAAAQAAAAAAAAAYAAAAAAAAAAEAAAANAAAAIJH1zoYhpCfbiSVl8I4zaiIxRArMi/njt4Kv8B4yRHwZAAAAAA==",
         result_meta_xdr:
           "AAAAAwAAAAIAAAADAAJNoAAAAAAAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYAAAAXSHHC9gAAdlkAAAAEAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAwAAAAAAAk1cAAAAAGR6YLAAAAAAAAAAAQACTaAAAAAAAAAAAMlOeOVhwnFIoNq3vyNsTIORWqja6Gk1fgF0G2oavH7WAAAAF0hxwvYAAHZZAAAABQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAAJNoAAAAABkemIRAAAAAAAAAAEAAAABAAAAAAACTaAAAAAGkfXOhiGkJ9uJJWXwjjNqIjFECsyL+eO3gq/wHjJEfBkAAAAUAAAAEgAAAAC7u0W71jGn1HRVU31RHkxALif4ynfRG6iiRh4VcL5wGgAAAAAAAAAAAAAAAQAAAAAAAAAAAACTEQAAAAAAAAABAAAAAAAAABgAAAAAAAAAAQAAAA0AAAAgkfXOhiGkJ9uJJWXwjjNqIjFECsyL+eO3gq/wHjJEfBkAAAAA8zw74WneXsJqBG8/SUG46bIxecWJOKG+wKUGs2uXq1PLvEh1Deu4U1CTs96viKx/TP+HQlV2pY3iusdUrNtGFsj9bldqgCRW73HAbe0FoeotGowWup59ixILJHVoD1t5AAAAAA=="
       }}

    %{
      source_public: "GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3",
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      asset_code: "ZZZ",
      transaction_response: transaction_response,
      envelope_xdr:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gABNuQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAQAAAAEAAAACAAAAAVpaWgAAAAAAWjshnxvxlOorTtBJXCh3BalUvn2zeWxrcNMgwsFisdoAAAABAAAAAAAAAAEAAAADAAAAAAAAAABi/B0L0JGythwN1lY0aypo19NHxvLCyO5tBEcCVvwF9wAAAAbhq+vRxjISTR62JpK1SAnzz1cZKpSpkRlwLJH6ZrzssgAAABQAAAAHzMOEndlMweZ0GOVWH/t3UcN2j5AjVlcaZ5HMHBUChVcAAAABAAAABuGr69HGMhJNHrYmkrVICfPPVxkqlKmRGXAskfpmvOyyAAAAFQAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcAJv++AAAVxAAAALQAAAGsAAAAAAAAAFQAAAAAAAAAAA=="
    }
  end

  test "deploy/2", %{
    asset_code: asset_code,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "308f5f3c7b2c0a690e7e19b6d14c22af87763f5ae483d6d1af43b9639732d206",
       latest_ledger: "602691",
       latest_ledger_close_time: "1683814245",
       error_result_xdr: nil
     }} = DeployAssetContract.deploy(asset_code, source_secret)
  end

  test "retrieve_unsigned_xdr_to_deploy_asset/2", %{
    asset_code: asset_code,
    source_public: source_public,
    envelope_xdr: envelope_xdr
  } do
    ^envelope_xdr =
      DeployAssetContract.retrieve_unsigned_xdr_to_deploy_asset(asset_code, source_public)
  end

  test "get_contract_id/1", %{
    transaction_response: transaction_response
  } do
    "91f5ce8621a427db892565f08e336a2231440acc8bf9e3b782aff01e32447c19" =
      DeployAssetContract.get_contract_id(transaction_response)
  end
end
