defmodule Stellar.Horizon.Client.CannedAccountRequests do
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
        @base_url <> "/accounts/GDDZSR7Y6TIMSBM72WYVGUH6FB6P7MF6Y6DU7MCNAPFRXI5GCWGWWFRS",
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

  def request(
        :get,
        @base_url <> "/accounts/GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM",
        _headers,
        _body,
        _opts
      ) do
    {:ok, 200, [], "{\"sequence\":\"1390916568875069\"}"}
  end
end

defmodule Soroban.RPC.CannedInvokeContractFunctionClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAWjshnxvxlOorTtBJXCh3BalUvn2zeWxrcNMgwsFisdoAAAAYAAAAAQAAAAAAAAADAAAADQAAACC+QTizHMXQ2dkbUxk9dDFtJUQGeU7A+B0+1A9NwbhqbgAAAA8AAAANZnVuY3Rpb25fbmFtZQAAAAAAAA8AAAADQXJnAAAAAAAAAAAAAAAAAA=="
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
            "AAAAAgAAAADHmUf49NDJBZ/VsVNQ/ih8/7C+x4dPsE0DyxujphWNawAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAx5lH+PTQyQWf1bFTUP4ofP+wvseHT7BNA8sbo6YVjWsAAAAYAAAAAQAAAAAAAAADAAAADQAAACC+QTizHMXQ2dkbUxk9dDFtJUQGeU7A+B0+1A9NwbhqbgAAAA8AAAANZnVuY3Rpb25fbmFtZQAAAAAAAA8AAAADQXJnAAAAAAAAAAAAAAAAAA=="
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
           auth: [
             "AAAAAQAAAAAAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYAAAAAAAAABb5BOLMcxdDZ2RtTGT10MW0lRAZ5TsD4HT7UD03BuGpuAAAABHN3YXAAAAACAAAACgAAAAAAAABkAAAAAAAAAAAAAAAKAAAAAAAAEZQAAAAAAAAAAAAAAAAAAAAA"
           ],
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
            "AAAAAgAAAAAljujNNVRGXkY/6yFmCo2gxEB/+nu1HuQIK6C4dj+KMQAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAJY7ozTVURl5GP+shZgqNoMRAf/p7tR7kCCuguHY/ijEAAAAYAAAAAQAAAAAAAAADAAAADQAAACC+QTizHMXQ2dkbUxk9dDFtJUQGeU7A+B0+1A9NwbhqbgAAAA8AAAANZnVuY3Rpb25fbmFtZQAAAAAAAA8AAAADQXJnAAAAAAAAAAAAAAAAAA=="
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

  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAADJTnjlYcJxSKDat78jbEyDkVqo2uhpNX4BdBtqGrx+1gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYAAAAYAAAAAQAAAAAAAAADAAAADQAAACC+QTizHMXQ2dkbUxk9dDFtJUQGeU7A+B0+1A9NwbhqbgAAAA8AAAANZnVuY3Rpb25fbmFtZQAAAAAAAA8AAAADQXJnAAAAAAAAAAAAAAAAAA=="
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
       cost: %{cpu_insns: "1052105", mem_bytes: "1201148"},
       latest_ledger: "690189",
       error: nil
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

defmodule Soroban.Contract.InvokeContractFunctionTest do
  use ExUnit.Case

  alias Soroban.Contract.InvokeContractFunction
  alias Soroban.Types.Symbol

  alias Soroban.RPC.{
    CannedInvokeContractFunctionClientImpl,
    SendTransactionResponse,
    SimulateTransactionResponse
  }

  alias Stellar.Horizon.Client.CannedAccountRequests

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedAccountRequests)
    Application.put_env(:soroban, :http_client_impl, CannedInvokeContractFunctionClientImpl)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{
      contract_id: "be4138b31cc5d0d9d91b53193d74316d254406794ec0f81d3ed40f4dc1b86a6e",
      source_public: "GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM",
      # GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      # GDDZSR7Y6TIMSBM72WYVGUH6FB6P7MF6Y6DU7MCNAPFRXI5GCWGWWFRS
      source_secret_with_auth: "SCFQVIK6JH2NNVWVZFQBA7FRKPYHIAGOMMGO32RZKTQ3QUTLU5DN67MG",
      source_public_with_error: "GASY52GNGVKEMXSGH7VSCZQKRWQMIQD77J53KHXEBAV2BODWH6FDDZ3F",
      source_secret_with_error: "SDXKY6TSBNS7T2UJMHLIH4BWTP4EHR52HZTRNEKH33ML3ARJI2AKIPEC",
      function_name: "function_name",
      function_args: [Symbol.new("Arg")],
      auth_secret_key: "SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK",
      xdr_envelope:
        "AAAAAgAAAADJTnjlYcJxSKDat78jbEyDkVqo2uhpNX4BdBtqGrx+1gABNuQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYAAAAYAAAAAQAAAAAAAAADAAAADQAAACC+QTizHMXQ2dkbUxk9dDFtJUQGeU7A+B0+1A9NwbhqbgAAAA8AAAANZnVuY3Rpb25fbmFtZQAAAAAAAA8AAAADQXJnAAAAAAAAAAABAAAAAwAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcAAAAG4avr0cYyEk0etiaStUgJ889XGSqUqZEZcCyR+ma87LIAAAAUAAAAB8zDhJ3ZTMHmdBjlVh/7d1HDdo+QI1ZXGmeRzBwVAoVXAAAAAQAAAAbhq+vRxjISTR62JpK1SAnzz1cZKpSpkRlwLJH6ZrzssgAAABUAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3ACb/vgAAFcQAAAC0AAABrAAAAAAAAABUAAAAAAAAAAA="
    }
  end

  test "invoke host function without authorization", %{
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
      InvokeContractFunction.invoke(
        contract_id,
        source_secret,
        function_name,
        function_args
      )
  end

  test "invoke host function with signed authorization", %{
    contract_id: contract_id,
    source_secret_with_auth: source_secret_with_auth,
    function_name: function_name,
    function_args: function_args,
    auth_secret_key: auth_secret_key
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      InvokeContractFunction.invoke(
        contract_id,
        source_secret_with_auth,
        function_name,
        function_args,
        auth_secret_key
      )
  end

  test "invoke host function without signed authorization", %{
    contract_id: contract_id,
    source_secret_with_auth: source_secret_with_auth,
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
      InvokeContractFunction.invoke(
        contract_id,
        source_secret_with_auth,
        function_name,
        function_args
      )
  end

  test "invoke host function with simulate error", %{
    contract_id: contract_id,
    source_secret_with_error: source_secret_with_error,
    function_name: function_name,
    function_args: function_args
  } do
    {:ok,
     %SimulateTransactionResponse{
       error: "error"
     }} =
      InvokeContractFunction.invoke(
        contract_id,
        source_secret_with_error,
        function_name,
        function_args
      )
  end

  test "retrieve_unsigned_xdr_to_invoke without authorization", %{
    contract_id: contract_id,
    source_public: source_public,
    function_name: function_name,
    function_args: function_args,
    xdr_envelope: xdr_envelope
  } do
    ^xdr_envelope =
      InvokeContractFunction.retrieve_unsigned_xdr_to_invoke(
        contract_id,
        source_public,
        function_name,
        function_args
      )
  end

  test "retrieve_unsigned_xdr_to_invoke host function with simulate error", %{
    contract_id: contract_id,
    source_public_with_error: source_public_with_error,
    function_name: function_name,
    function_args: function_args
  } do
    {:ok,
     %SimulateTransactionResponse{
       error: "error"
     }} =
      InvokeContractFunction.retrieve_unsigned_xdr_to_invoke(
        contract_id,
        source_public_with_error,
        function_name,
        function_args
      )
  end
end
