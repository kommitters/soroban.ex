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

  def request(
        :get,
        @base_url <> "/accounts/GCODO4TKGGIBN2EWNFXTJADNYIQOPQ2XUO6IBSCHA2NM4CGTKL2TJTRE",
        _headers,
        _body,
        _opts
      ) do
    {:ok, 200, [], "{\"sequence\":\"1390916568875069\"}"}
  end

  def request(
        :get,
        @base_url <> "/accounts/GCJFPGZINFE3WI6PAKCT42OMI35UMTXZZ6DT6VZOSEIK3YORRXWDEGOM",
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
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAWjshnxvxlOorTtBJXCh3BalUvn2zeWxrcNMgwsFisdoAAAAYAAAAAAAAAAMAAAASAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAADwAAAA1mdW5jdGlvbl9uYW1lAAAAAAAADwAAAANBcmcAAAAAAAAAAAAAAAAA"
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
            "AAAAAgAAAADHmUf49NDJBZ/VsVNQ/ih8/7C+x4dPsE0DyxujphWNawAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAx5lH+PTQyQWf1bFTUP4ofP+wvseHT7BNA8sbo6YVjWsAAAAYAAAAAAAAAAMAAAASAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAADwAAAA1mdW5jdGlvbl9uYW1lAAAAAAAADwAAAANBcmcAAAAAAAAAAAAAAAAA"
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       transaction_data:
         "AAAAAAAAAAEAAAAHmDXys1KuBimD87u2AiUG/jb5CqOkQW/qASpb6gMVRlsAAAAAAAAAAQAAAAYAAAAB9naqmyRmTCwhDWcnYJzK9ZtX7TrgjMYqFwQWszcX0SAAAAAUAAAAAQAAAAAAN4HKAAAU9AAAAWAAAAPUAAAAAAAAAMA=",
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
            "AAAAAgAAAAAljujNNVRGXkY/6yFmCo2gxEB/+nu1HuQIK6C4dj+KMQAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAJY7ozTVURl5GP+shZgqNoMRAf/p7tR7kCCuguHY/ijEAAAAYAAAAAAAAAAMAAAASAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAADwAAAA1mdW5jdGlvbl9uYW1lAAAAAAAADwAAAANBcmcAAAAAAAAAAAAAAAAA"
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
            "AAAAAgAAAADJTnjlYcJxSKDat78jbEyDkVqo2uhpNX4BdBtqGrx+1gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYAAAAYAAAAAAAAAAMAAAASAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAADwAAAA1mdW5jdGlvbl9uYW1lAAAAAAAADwAAAANBcmcAAAAAAAAAAAAAAAAA"
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
           events: nil,
           xdr: "AAAAEAAAAAEAAAACAAAADwAAAAVIZWxsbwAAAAAAAA8AAAAFd29ybGQAAAA="
         }
       ],
       cost: %{cpu_insns: "1052105", mem_bytes: "1201148"},
       latest_ledger: "690189",
       error: nil
     }}
  end

  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAACcN3JqMZAW6JZpbzSAbcIg58NXo7yAyEcGms4I01L1NAAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAnDdyajGQFuiWaW80gG3CIOfDV6O8gMhHBprOCNNS9TQAAAAYAAAAAAAAAAMAAAASAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAADwAAAA1mdW5jdGlvbl9uYW1lAAAAAAAADwAAAANBcmcAAAAAAAAAAAAAAAAA"
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       transaction_data:
         "AAAAAAAAAAEAAAAHmDXys1KuBimD87u2AiUG/jb5CqOkQW/qASpb6gMVRlsAAAAAAAAAAQAAAAYAAAAB9naqmyRmTCwhDWcnYJzK9ZtX7TrgjMYqFwQWszcX0SAAAAAUAAAAAQAAAAAAN4HKAAAU9AAAAWAAAAPUAAAAAAAAAMA=",
       events: nil,
       min_resource_fee: "79488",
       results: [
         %{
           auth: [
             "AAAAAQAAAAAAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftZXNpultrwTUAAAAAAAAAAAAAAAAAAAAAH5tV8LM6MblBMlB7cp0DcehSyr70sSTZsTzo1ahdNYVAAAAARzd2FwAAAAAgAAAAoAAAAAAAAAAAAAAAAAAABkAAAACgAAAAAAAAAAAAAAAAAAEZQAAAAA"
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
            "AAAAAgAAAACSV5soaUm7I88ChT5pzEb7Rk75z4c/Vy6REK3h0Y3sMgAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAklebKGlJuyPPAoU+acxG+0ZO+c+HP1cukRCt4dGN7DIAAAAYAAAAAAAAAAMAAAASAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAADwAAAA1mdW5jdGlvbl9uYW1lAAAAAAAADwAAAANBcmcAAAAAAAAAAAAAAAAA"
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       transaction_data:
         "AAAAAAAAAAEAAAAHmDXys1KuBimD87u2AiUG/jb5CqOkQW/qASpb6gMVRlsAAAAAAAAAAQAAAAYAAAAB9naqmyRmTCwhDWcnYJzK9ZtX7TrgjMYqFwQWszcX0SAAAAAUAAAAAQAAAAAAN4HKAAAU9AAAAWAAAAPUAAAAAAAAAMA=",
       events: nil,
       min_resource_fee: "79488",
       results: [
         %{
           auth: [
             "AAAAAQAAAAAAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftZXNpultrwTUAAAAAAAAAAAAAAAAAAAAAH5tV8LM6MblBMlB7cp0DcehSyr70sSTZsTzo1ahdNYVAAAAARzd2FwAAAAAgAAAAoAAAAAAAAAAAAAAAAAAABkAAAACgAAAAAAAAAAAAAAAAAAEZQAAAAA",
             "AAAAAQAAAAAAAAAAwH2t7Rb1TR1p5RQ5G0eSW+7ebMqBlCOZ41wClsmaNPoW3+w0mXsgEwAAAAAAAAAAAAAAAAAAAAH5tV8LM6MblBMlB7cp0DcehSyr70sSTZsTzo1ahdNYVAAAAARzd2FwAAAAAgAAAAoAAAAAAAAAAAAAAAAAABGUAAAACgAAAAAAAAAAAAAAAAAAAGQAAAAA"
           ],
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
      contract_address: "CD3HNKU3ERTEYLBBBVTSOYE4ZL2ZWV7NHLQIZRRKC4CBNMZXC7ISBXHV",
      source_public: "GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM",
      # GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      # GDDZSR7Y6TIMSBM72WYVGUH6FB6P7MF6Y6DU7MCNAPFRXI5GCWGWWFRS
      source_secret_with_auth: "SCFQVIK6JH2NNVWVZFQBA7FRKPYHIAGOMMGO32RZKTQ3QUTLU5DN67MG",
      # GCODO4TKGGIBN2EWNFXTJADNYIQOPQ2XUO6IBSCHA2NM4CGTKL2TJTRE
      source_secret_with_auths: "SAXEQ7CYV5MA3RUCTWWSUBPA3SVZYT2IDXO5WPYRI34POHUBOBDPVYPT",
      # GCJFPGZINFE3WI6PAKCT42OMI35UMTXZZ6DT6VZOSEIK3YORRXWDEGOM
      source_secret_auths_error: "SDDDMA6TT5FYTI33HBFLDCWJPJL5QFZU53B3246XYGZQ3EOQX74TFQ4I",
      source_public_with_error: "GASY52GNGVKEMXSGH7VSCZQKRWQMIQD77J53KHXEBAV2BODWH6FDDZ3F",
      source_secret_with_error: "SDXKY6TSBNS7T2UJMHLIH4BWTP4EHR52HZTRNEKH33ML3ARJI2AKIPEC",
      function_name: "function_name",
      function_args: [Symbol.new("Arg")],
      auth_secret_keys: ["SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK"],
      xdr_envelope:
        "AAAAAgAAAADJTnjlYcJxSKDat78jbEyDkVqo2uhpNX4BdBtqGrx+1gABOf8ABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYAAAAYAAAAAAAAAAMAAAASAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAADwAAAA1mdW5jdGlvbl9uYW1lAAAAAAAADwAAAANBcmcAAAAAAAAAAAEAAAAAAAAAAgAAAAYAAAAB9naqmyRmTCwhDWcnYJzK9ZtX7TrgjMYqFwQWszcX0SAAAAAUAAAAAQAAAAAAAAAHmDXys1KuBimD87u2AiUG/jb5CqOkQW/qASpb6gMVRlsAAAAAAAAAAAA1i+AAABQ4AAAAAAAAAPAAAAAAAAAALwAAAAA="
    }
  end

  test "invoke host function without authorization", %{
    contract_address: contract_address,
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
        contract_address,
        source_secret,
        function_name,
        function_args
      )
  end

  test "invoke host function without signed authorization", %{
    contract_address: contract_address,
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
        contract_address,
        source_secret_with_auth,
        function_name,
        function_args
      )
  end

  test "invoke host function with signed authorization", %{
    contract_address: contract_address,
    source_secret_with_auths: source_secret_with_auths,
    function_name: function_name,
    function_args: function_args,
    auth_secret_keys: auth_secret_keys
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
        contract_address,
        source_secret_with_auths,
        function_name,
        function_args,
        auth_secret_keys
      )
  end

  test "simulate invoke", %{
    contract_address: contract_address,
    source_public: source_public,
    function_name: function_name,
    function_args: function_args
  } do
    {:ok,
     %SimulateTransactionResponse{
       transaction_data:
         "AAAAAAAAAAIAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAFAAAAAEAAAAAAAAAB5g18rNSrgYpg/O7tgIlBv42+QqjpEFv6gEqW+oDFUZbAAAAAAAAAAAANYvgAAAUOAAAAAAAAADwAAAAAAAAAC8=",
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
     }} =
      InvokeContractFunction.simulate_invoke(
        contract_address,
        source_public,
        function_name,
        function_args
      )
  end

  test "invoke host function invalid length of auth keys", %{
    contract_address: contract_address,
    source_secret_auths_error: source_secret_auths_error,
    function_name: function_name,
    function_args: function_args,
    auth_secret_keys: auth_secret_keys
  } do
    {:error, :invalid_auth_secret_keys_length} =
      InvokeContractFunction.invoke(
        contract_address,
        source_secret_auths_error,
        function_name,
        function_args,
        auth_secret_keys
      )
  end

  test "invoke host function with simulate error", %{
    contract_address: contract_address,
    source_secret_with_error: source_secret_with_error,
    function_name: function_name,
    function_args: function_args
  } do
    {:ok,
     %SimulateTransactionResponse{
       error: "error"
     }} =
      InvokeContractFunction.invoke(
        contract_address,
        source_secret_with_error,
        function_name,
        function_args
      )
  end

  test "retrieve_unsigned_xdr_to_invoke without authorization", %{
    contract_address: contract_address,
    source_public: source_public,
    function_name: function_name,
    function_args: function_args,
    xdr_envelope: xdr_envelope
  } do
    ^xdr_envelope =
      InvokeContractFunction.retrieve_unsigned_xdr_to_invoke(
        contract_address,
        source_public,
        function_name,
        function_args
      )
  end

  test "retrieve_unsigned_xdr_to_invoke host function with simulate error", %{
    contract_address: contract_address,
    source_public_with_error: source_public_with_error,
    function_name: function_name,
    function_args: function_args
  } do
    {:ok,
     %SimulateTransactionResponse{
       error: "error"
     }} =
      InvokeContractFunction.retrieve_unsigned_xdr_to_invoke(
        contract_address,
        source_public_with_error,
        function_name,
        function_args
      )
  end
end
