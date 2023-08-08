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
    SendTransactionResponse,
    SimulateTransactionResponse
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
      contract_address: "CD3HNKU3ERTEYLBBBVTSOYE4ZL2ZWV7NHLQIZRRKC4CBNMZXC7ISBXHV",
      source_public: "GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3",
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      function_name: "function_name",
      function_args: [Symbol.new("Arg")],
      auth_secret_keys: ["SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK"],
      asset_code: :ZZZ,
      wasm:
        <<0, 97, 115, 109, 1, 0, 0, 0, 1, 65, 12, 96, 1, 126, 1, 126, 96, 2, 126, 126, 1, 126, 96,
          3, 126, 126, 126, 1, 126, 96, 0, 1, 126, 96, 4, 126, 126, 126, 126, 1, 126, 96, 1, 126,
          1, 127, 96, 2, 127, 126>>,
      wasm_id:
        <<66, 208, 35, 40, 82, 63, 24, 62, 0, 161, 91, 200, 46, 101, 45, 24, 216, 140, 130, 169,
          254, 217, 11, 131, 45, 9, 151, 5, 194, 188, 205, 26>>,
      bump_wasm_id: "067eb7ba419edd3e946e08eb17a81fbe1e850e690ed7692160875c2b65b45f21",
      keys: [{:temporary, "Tmp"}, {:persistent, "Per"}],
      ledgers_to_bump: 100_000,
      xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gABOf8ABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAWjshnxvxlOorTtBJXCh3BalUvn2zeWxrcNMgwsFisdoAAAAYAAAAAAAAAAMAAAASAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAADwAAAA1mdW5jdGlvbl9uYW1lAAAAAAAADwAAAANBcmcAAAAAAAAAAAEAAAAAAAAAAgAAAAYAAAAB9naqmyRmTCwhDWcnYJzK9ZtX7TrgjMYqFwQWszcX0SAAAAAUAAAAAQAAAAAAAAAHmDXys1KuBimD87u2AiUG/jb5CqOkQW/qASpb6gMVRlsAAAAAAAAAAAA1i+AAABQ4AAAAAAAAAPAAAAAAAAAALwAAAAA=",
      no_args_xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gABOf8ABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAWjshnxvxlOorTtBJXCh3BalUvn2zeWxrcNMgwsFisdoAAAAYAAAAAAAAAAIAAAASAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAADwAAAA1mdW5jdGlvbl9uYW1lAAAAAAAAAAAAAAEAAAAAAAAAAgAAAAYAAAAB9naqmyRmTCwhDWcnYJzK9ZtX7TrgjMYqFwQWszcX0SAAAAAUAAAAAQAAAAAAAAAHmDXys1KuBimD87u2AiUG/jb5CqOkQW/qASpb6gMVRlsAAAAAAAAAAAA1i+AAABQ4AAAAAAAAAPAAAAAAAAAALwAAAAA=",
      upload_xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gABOf8ABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAgAAADIAYXNtAQAAAAFBDGABfgF+YAJ+fgF+YAN+fn4BfmAAAX5gBH5+fn4BfmABfgF/YAJ/fgAAAAAAAAAAAAEAAAAAAAAAAgAAAAYAAAAB9naqmyRmTCwhDWcnYJzK9ZtX7TrgjMYqFwQWszcX0SAAAAAUAAAAAQAAAAAAAAAHmDXys1KuBimD87u2AiUG/jb5CqOkQW/qASpb6gMVRlsAAAAAAAAAAAA1i+AAABQ4AAAAAAAAAPAAAAAAAAAALwAAAAA=",
      deploy_xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAgAAACBC0CMoUj8YPgChW8guZS0Y2IyCqf7ZC4MtCZcFwrzNGgAAAAIAAAAGFNBLmawioIDIHGB7cDLoh6p62MIZLDte5H48CfIdpd0AAAAUAAAABwqCq7aoMU3MQSfhfSV/txr5cNzbWBsArvIc8VLG7qcCAAAAAAAAAAAAAAAAAAAAAA==",
      asset_deploy_xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gABOf8ABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAQAAAAEAAAABWlpaAAAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAAEAAAAAAAAAAQAAAAAAAAACAAAABgAAAAH2dqqbJGZMLCENZydgnMr1m1ftOuCMxioXBBazNxfRIAAAABQAAAABAAAAAAAAAAeYNfKzUq4GKYPzu7YCJQb+NvkKo6RBb+oBKlvqAxVGWwAAAAAAAAAAADWL4AAAFDgAAAAAAAAA8AAAAAAAAAAvAAAAAA=="
    }
  end

  test "invoke/5", %{
    contract_address: contract_address,
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
        contract_address,
        source_secret,
        function_name
      )
  end

  test "invoke/5 with args", %{
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
      Contract.invoke(
        contract_address,
        source_secret,
        function_name,
        function_args
      )
  end

  test "invoke/5 with args and auth_secret_keys", %{
    auth_secret_keys: auth_secret_keys,
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
      Contract.invoke(
        contract_address,
        source_secret,
        function_name,
        function_args,
        auth_secret_keys
      )
  end

  test "simulate_invoke/5", %{
    contract_address: contract_address,
    source_public: source_public,
    function_name: function_name
  } do
    {:ok,
     %SimulateTransactionResponse{
       transaction_data:
         "AAAAAAAAAAIAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAFAAAAAEAAAAAAAAAB5g18rNSrgYpg/O7tgIlBv42+QqjpEFv6gEqW+oDFUZbAAAAAAAAAAAANYvgAAAUOAAAAAAAAADwAAAAAAAAAC8=",
       events: nil,
       min_resource_fee: "79488",
       results: [
         %{auth: nil, xdr: "AAAAEAAAAAEAAAACAAAADwAAAAVIZWxsbwAAAAAAAA8AAAAFd29ybGQAAAA="}
       ],
       cost: %{cpu_insns: "1048713", mem_bytes: "1201148"},
       latest_ledger: "475528",
       error: nil
     }} =
      Contract.simulate_invoke(
        contract_address,
        source_public,
        function_name
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

  test "bump_contract/3", %{
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_bump: ledgers_to_bump
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      Contract.bump_contract(
        contract_address,
        source_secret,
        ledgers_to_bump
      )
  end

  test "bump_contract_wasm/3", %{
    bump_wasm_id: bump_wasm_id,
    source_secret: source_secret,
    ledgers_to_bump: ledgers_to_bump
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      Contract.bump_contract_wasm(
        bump_wasm_id,
        source_secret,
        ledgers_to_bump
      )
  end

  test "bump_contract_keys/4", %{
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_bump: ledgers_to_bump,
    keys: keys
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: "476420",
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil
     }} =
      Contract.bump_contract_keys(
        contract_address,
        source_secret,
        ledgers_to_bump,
        keys
      )
  end

  test "retrieve_unsigned_xdr_to_invoke/4", %{
    contract_address: contract_address,
    source_public: source_public,
    function_name: function_name,
    function_args: function_args,
    xdr_envelope: xdr_envelope
  } do
    ^xdr_envelope =
      Contract.retrieve_unsigned_xdr_to_invoke(
        contract_address,
        source_public,
        function_name,
        function_args
      )
  end

  test "retrieve_unsigned_xdr_to_invoke/4 without args", %{
    contract_address: contract_address,
    source_public: source_public,
    function_name: function_name,
    no_args_xdr_envelope: no_args_xdr_envelope
  } do
    ^no_args_xdr_envelope =
      Contract.retrieve_unsigned_xdr_to_invoke(
        contract_address,
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
