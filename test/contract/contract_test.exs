defmodule Stellar.Horizon.Client.ContractCannedAccountRequests do
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
end

defmodule Soroban.RPC.ContractCannedClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAAAAAAMAAAANAAAAIL5BOLMcxdDZ2RtTGT10MW0lRAZ5TsD4HT7UD03BuGpuAAAADwAAAA1mdW5jdGlvbl9uYW1lAAAAAAAADwAAAANBcmcAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
        },
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

  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAADHmUf49NDJBZ/VsVNQ/ih8/7C+x4dPsE0DyxujphWNawAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAAAAAAMAAAANAAAAIL5BOLMcxdDZ2RtTGT10MW0lRAZ5TsD4HT7UD03BuGpuAAAADwAAAA1mdW5jdGlvbl9uYW1lAAAAAAAADwAAAANBcmcAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       results: [
         %{
           auth: [
             "AAAAAQAAAAAAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYAAAAAAAAABb5BOLMcxdDZ2RtTGT10MW0lRAZ5TsD4HT7UD03BuGpuAAAABHN3YXAAAAACAAAACgAAAAAAAABkAAAAAAAAAAAAAAAKAAAAAAAAEZQAAAAAAAAAAAAAAAAAAAAA"
           ],
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

  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAAAljujNNVRGXkY/6yFmCo2gxEB/+nu1HuQIK6C4dj+KMQAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAAAAAAMAAAANAAAAIL5BOLMcxdDZ2RtTGT10MW0lRAZ5TsD4HT7UD03BuGpuAAAADwAAAA1mdW5jdGlvbl9uYW1lAAAAAAAADwAAAANBcmcAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
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
    ContractCannedClientImpl,
    SendTransactionResponse
  }

  alias Stellar.Horizon.Client.ContractCannedAccountRequests

  setup do
    Application.put_env(:stellar_sdk, :http_client, ContractCannedAccountRequests)
    Application.put_env(:soroban, :http_client_impl, ContractCannedClientImpl)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{
      contract_id: "be4138b31cc5d0d9d91b53193d74316d254406794ec0f81d3ed40f4dc1b86a6e",
      # GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      # GDDZSR7Y6TIMSBM72WYVGUH6FB6P7MF6Y6DU7MCNAPFRXI5GCWGWWFRS
      source_secret_with_auth: "SCFQVIK6JH2NNVWVZFQBA7FRKPYHIAGOMMGO32RZKTQ3QUTLU5DN67MG",
      # GASY52GNGVKEMXSGH7VSCZQKRWQMIQD77J53KHXEBAV2BODWH6FDDZ3F
      source_secret_with_error: "SDXKY6TSBNS7T2UJMHLIH4BWTP4EHR52HZTRNEKH33ML3ARJI2AKIPEC",
      function_name: "function_name",
      function_args: [Symbol.new("Arg")],
      auth_accounts: ["SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK"]
    }
  end

  test "invoke/5", %{
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
end
