defmodule Stellar.Horizon.Client.CannedContractAccountRequests do
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

defmodule Soroban.RPC.CannedContractClientImpl do
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
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612"
     }}
  end
end

defmodule Soroban.ContractTest do
  use ExUnit.Case

  alias Soroban.Contract
  alias Soroban.Types.Symbol

  alias Soroban.RPC.{
    CannedContractClientImpl,
    SendTransactionResponse
  }

  alias Stellar.Horizon.Client.CannedContractAccountRequests

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedContractAccountRequests)
    Application.put_env(:soroban, :http_client_impl, CannedContractClientImpl)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{
      contract_id: "be4138b31cc5d0d9d91b53193d74316d254406794ec0f81d3ed40f4dc1b86a6e",
      source_public: "GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3",
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      # GDDZSR7Y6TIMSBM72WYVGUH6FB6P7MF6Y6DU7MCNAPFRXI5GCWGWWFRS
      function_name: "function_name",
      function_args: [Symbol.new("Arg")],
      auth_secret_key: "SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK",
      asset_code: :ZZZ,
      wasm:
        <<0, 97, 115, 109, 1, 0, 0, 0, 1, 65, 12, 96, 1, 126, 1, 126, 96, 2, 126, 126, 1, 126, 96,
          3, 126, 126, 126, 1, 126, 96, 0, 1, 126, 96, 4, 126, 126, 126, 126, 1, 126, 96, 1, 126,
          1, 127, 96, 2, 127, 126>>,
      wasm_id:
        <<66, 208, 35, 40, 82, 63, 24, 62, 0, 161, 91, 200, 46, 101, 45, 24, 216, 140, 130, 169,
          254, 217, 11, 131, 45, 9, 151, 5, 194, 188, 205, 26>>,
      xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAWjshnxvxlOorTtBJXCh3BalUvn2zeWxrcNMgwsFisdoAAAAYAAAAAQAAAAAAAAADAAAADQAAACC+QTizHMXQ2dkbUxk9dDFtJUQGeU7A+B0+1A9NwbhqbgAAAA8AAAANZnVuY3Rpb25fbmFtZQAAAAAAAA8AAAADQXJnAAAAAAAAAAAAAAAAAA==",
      no_args_xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAWjshnxvxlOorTtBJXCh3BalUvn2zeWxrcNMgwsFisdoAAAAYAAAAAQAAAAAAAAACAAAADQAAACC+QTizHMXQ2dkbUxk9dDFtJUQGeU7A+B0+1A9NwbhqbgAAAA8AAAANZnVuY3Rpb25fbmFtZQAAAAAAAAAAAAAAAAAAAA==",
      upload_xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAQAAAAIAAAAyAGFzbQEAAAABQQxgAX4BfmACfn4BfmADfn5+AX5gAAF+YAR+fn5+AX5gAX4Bf2ACf34AAAAAAAAAAAAAAAAAAA==",
      deploy_xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAgAAACBC0CMoUj8YPgChW8guZS0Y2IyCqf7ZC4MtCZcFwrzNGgAAAAIAAAAGFNBLmawioIDIHGB7cDLoh6p62MIZLDte5H48CfIdpd0AAAAUAAAABwqCq7aoMU3MQSfhfSV/txr5cNzbWBsArvIc8VLG7qcCAAAAAAAAAAAAAAAAAAAAAA==",
      asset_deploy_xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAQAAAAEAAAACAAAAAVpaWgAAAAAAWjshnxvxlOorTtBJXCh3BalUvn2zeWxrcNMgwsFisdoAAAABAAAAAAAAAAAAAAAA"
    }
  end

  test "invoke/5", %{
    contract_id: contract_id,
    source_secret: source_secret,
    function_name: function_name
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      Contract.invoke(
        contract_id,
        source_secret,
        function_name
      )
  end

  test "invoke/5 with args", %{
    contract_id: contract_id,
    source_secret: source_secret,
    function_name: function_name,
    function_args: function_args
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      Contract.invoke(
        contract_id,
        source_secret,
        function_name,
        function_args
      )
  end

  test "invoke/5 with args and auth_secret_key", %{
    auth_secret_key: auth_secret_key,
    contract_id: contract_id,
    source_secret: source_secret,
    function_name: function_name,
    function_args: function_args
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      Contract.invoke(
        contract_id,
        source_secret,
        function_name,
        function_args,
        auth_secret_key
      )
  end

  test "upload/2", %{
    wasm: wasm,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      Contract.upload(
        wasm,
        source_secret
      )
  end

  test "deploy/2", %{
    wasm_id: wasm_id,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      Contract.deploy(
        wasm_id,
        source_secret
      )
  end

  test "deploy_asset/2", %{
    asset_code: asset_code,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      Contract.deploy_asset(
        asset_code,
        source_secret
      )
  end

  test "retrieve_unsigned_xdr_to_invoke/4", %{
    contract_id: contract_id,
    source_public: source_public,
    function_name: function_name,
    function_args: function_args,
    xdr_envelope: xdr_envelope
  } do
    ^xdr_envelope =
      Contract.retrieve_unsigned_xdr_to_invoke(
        contract_id,
        source_public,
        function_name,
        function_args
      )
  end

  test "retrieve_unsigned_xdr_to_invoke/4 without args", %{
    contract_id: contract_id,
    source_public: source_public,
    function_name: function_name,
    no_args_xdr_envelope: no_args_xdr_envelope
  } do
    ^no_args_xdr_envelope =
      Contract.retrieve_unsigned_xdr_to_invoke(
        contract_id,
        source_public,
        function_name
      )
  end

  test "retrieve_unsigned_xdr_to_upload/2", %{
    wasm: wasm,
    source_public: source_public,
    upload_xdr_envelope: upload_xdr_envelope
  } do
    ^upload_xdr_envelope =
      Contract.retrieve_unsigned_xdr_to_upload(
        wasm,
        source_public
      )
  end

  test "retrieve_unsigned_xdr_to_deploy/2", %{
    wasm_id: wasm_id,
    source_public: source_public
  } do
    assert String.contains?(
             Contract.retrieve_unsigned_xdr_to_deploy(
               wasm_id,
               source_public
             ),
             "AAAAAgAAAABaOyGfG"
           )
  end

  test "retrieve_unsigned_xdr_to_deploy_asset/2", %{
    asset_code: asset_code,
    source_public: source_public,
    asset_deploy_xdr_envelope: asset_deploy_xdr_envelope
  } do
    ^asset_deploy_xdr_envelope =
      Contract.retrieve_unsigned_xdr_to_deploy_asset(
        asset_code,
        source_public
      )
  end
end
