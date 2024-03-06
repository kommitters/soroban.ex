defmodule Soroban.RPC.CannedContractClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(
        "getLedgerEntries",
        _url,
        _headers,
        _body,
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       entries: [
         %{
           key: "AAAAAAAAAAB8VFyuIrnqhGA3aSvFShpwVwYZGwD3Yx5guKZGcn1ofQ==",
           last_modified_ledger_seq: 462_965,
           #  this xdr is a LedgerEntryData of type account with sequence number 1_390_916_568_875_069
           xdr:
             "AAAAAAAAAAB8VFyuIrnqhGA3aSvFShpwVwYZGwD3Yx5guKZGcn1ofQAAABdIdugAAATxCAAAAD0AAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA"
         }
       ],
       latest_ledger: 462_966
     }}
  end

  @impl true
  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAZAAAAAAABhqAAAAABAAAAAAAAAAEAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAFAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    simulate_request_without_results()
  end

  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAZAAAAAAABhqAAAAABAAAAAAAAAAEAAAAHBn63ukGe3T6UbgjrF6gfvh6FDmkO12khYIdcK2W0XyEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    simulate_request_without_results()
  end

  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAZAAAAAAABhqAAAAABAAAAAAAAAAIAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAEAAAAAEAAAABAAAADwAAAANUbXAAAAAAAAAAAAYAAAAB9naqmyRmTCwhDWcnYJzK9ZtX7TrgjMYqFwQWszcX0SAAAAAQAAAAAQAAAAEAAAAPAAAAA1BlcgAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    simulate_request_without_results()
  end

  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAaAAAAAAAAAAEAAAAAAAAAAAAAAAEAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAFAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    simulate_request_without_results()
  end

  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAaAAAAAAAAAAEAAAAAAAAAAAAAAAEAAAAHBn63ukGe3T6UbgjrF6gfvh6FDmkO12khYIdcK2W0XyEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    simulate_request_without_results()
  end

  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAaAAAAAAAAAAEAAAAAAAAAAAAAAAEAAAAGAAAAAfZ2qpskZkwsIQ1nJ2CcyvWbV+064IzGKhcEFrM3F9EgAAAAEAAAAAEAAAABAAAADwAAAApQZXJzaXN0ZW50AAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})
    simulate_request_without_results()
  end

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
           auth: nil,
           xdr: "AAAAEAAAAAEAAAACAAAADwAAAAVIZWxsbwAAAAAAAA8AAAAFd29ybGQAAAA="
         }
       ],
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
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612"
     }}
  end

  defp simulate_request_without_results do
    {:ok,
     %{
       transaction_data:
         "AAAAAAAAAAIAAAAGAAAAAQmM+SjuK6EFG2xjRoNDYSKeKWmaP+sPIZ2z+rHmx5I0AAAAFAAAAAEAAAAHjDfZjX1lF+yHF4743DgE1KQTRmGJtwRYh3hJXOzQ9k8AAAAAAE74MAAAGPAAAAAAAAAAAAAAAA0=",
       events: nil,
       min_resource_fee: "79488",
       results: nil,
       cost: %{cpu_insns: "1048713", mem_bytes: "1201148"},
       latest_ledger: 45_075_181
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
    Server,
    SimulateTransactionResponse
  }

  alias Stellar.Network

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedContractClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{
      server: Server.testnet(),
      network_passphrase: Network.testnet_passphrase(),
      extra_fee_rate: 0.05,
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
      extend_wasm_id: "067eb7ba419edd3e946e08eb17a81fbe1e850e690ed7692160875c2b65b45f21",
      keys: [{:temporary, "Tmp"}, {:persistent, "Per"}],
      ledgers_to_extend: 100_000,
      xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gABNuQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAWjshnxvxlOorTtBJXCh3BalUvn2zeWxrcNMgwsFisdoAAAAYAAAAAAAAAAH2dqqbJGZMLCENZydgnMr1m1ftOuCMxioXBBazNxfRIAAAAA1mdW5jdGlvbl9uYW1lAAAAAAAAAQAAAA8AAAADQXJnAAAAAAAAAAABAAAAAAAAAAIAAAAGAAAAAQmM+SjuK6EFG2xjRoNDYSKeKWmaP+sPIZ2z+rHmx5I0AAAAFAAAAAEAAAAHjDfZjX1lF+yHF4743DgE1KQTRmGJtwRYh3hJXOzQ9k8AAAAAAE74MAAAGPAAAAAAAAAAAAAAAA0AAAAA",
      no_args_xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gABNuQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAEAAAAAWjshnxvxlOorTtBJXCh3BalUvn2zeWxrcNMgwsFisdoAAAAYAAAAAAAAAAH2dqqbJGZMLCENZydgnMr1m1ftOuCMxioXBBazNxfRIAAAAA1mdW5jdGlvbl9uYW1lAAAAAAAAAAAAAAAAAAABAAAAAAAAAAIAAAAGAAAAAQmM+SjuK6EFG2xjRoNDYSKeKWmaP+sPIZ2z+rHmx5I0AAAAFAAAAAEAAAAHjDfZjX1lF+yHF4743DgE1KQTRmGJtwRYh3hJXOzQ9k8AAAAAAE74MAAAGPAAAAAAAAAAAAAAAA0AAAAA",
      upload_xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gABNuQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAgAAADIAYXNtAQAAAAFBDGABfgF+YAJ+fgF+YAN+fn4BfmAAAX5gBH5+fn4BfmABfgF/YAJ/fgAAAAAAAAAAAAEAAAAAAAAAAgAAAAYAAAABCYz5KO4roQUbbGNGg0NhIp4paZo/6w8hnbP6sebHkjQAAAAUAAAAAQAAAAeMN9mNfWUX7IcXjvjcOATUpBNGYYm3BFiHeElc7ND2TwAAAAAATvgwAAAY8AAAAAAAAAAAAAAADQAAAAA=",
      deploy_xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAgAAACBC0CMoUj8YPgChW8guZS0Y2IyCqf7ZC4MtCZcFwrzNGgAAAAIAAAAGFNBLmawioIDIHGB7cDLoh6p62MIZLDte5H48CfIdpd0AAAAUAAAABwqCq7aoMU3MQSfhfSV/txr5cNzbWBsArvIc8VLG7qcCAAAAAAAAAAAAAAAAAAAAAA==",
      asset_deploy_xdr_envelope:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gABNuQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAQAAAAEAAAABWlpaAAAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAAEAAAAAAAAAAQAAAAAAAAACAAAABgAAAAEJjPko7iuhBRtsY0aDQ2Einilpmj/rDyGds/qx5seSNAAAABQAAAABAAAAB4w32Y19ZRfshxeO+Nw4BNSkE0ZhibcEWId4SVzs0PZPAAAAAABO+DAAABjwAAAAAAAAAAAAAAANAAAAAA=="
    }
  end

  test "invoke/5", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_secret: source_secret,
    function_name: function_name
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.invoke(
        server,
        network_passphrase,
        contract_address,
        source_secret,
        function_name
      )
  end

  test "invoke/6 with args", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_secret: source_secret,
    function_name: function_name,
    function_args: function_args
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.invoke(
        server,
        network_passphrase,
        contract_address,
        source_secret,
        function_name,
        function_args
      )
  end

  test "invoke/7 with args and fix fee", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_secret: source_secret,
    function_name: function_name,
    function_args: function_args,
    extra_fee_rate: extra_fee_rate
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.invoke(
        server,
        network_passphrase,
        contract_address,
        source_secret,
        function_name,
        function_args,
        extra_fee_rate
      )
  end

  test "invoke/8 with args and auth_secret_keys", %{
    server: server,
    network_passphrase: network_passphrase,
    auth_secret_keys: auth_secret_keys,
    contract_address: contract_address,
    source_secret: source_secret,
    function_name: function_name,
    function_args: function_args,
    extra_fee_rate: extra_fee_rate
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.invoke(
        server,
        network_passphrase,
        contract_address,
        source_secret,
        function_name,
        function_args,
        extra_fee_rate,
        auth_secret_keys
      )
  end

  test "simulate_invoke/5", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_public: source_public,
    function_name: function_name
  } do
    {:ok,
     %SimulateTransactionResponse{
       transaction_data:
         "AAAAAAAAAAIAAAAGAAAAAQmM+SjuK6EFG2xjRoNDYSKeKWmaP+sPIZ2z+rHmx5I0AAAAFAAAAAEAAAAHjDfZjX1lF+yHF4743DgE1KQTRmGJtwRYh3hJXOzQ9k8AAAAAAE74MAAAGPAAAAAAAAAAAAAAAA0=",
       events: nil,
       min_resource_fee: 79_488,
       results: [
         %{auth: nil, xdr: "AAAAEAAAAAEAAAACAAAADwAAAAVIZWxsbwAAAAAAAA8AAAAFd29ybGQAAAA="}
       ],
       cost: %{cpu_insns: "1048713", mem_bytes: "1201148"},
       latest_ledger: 45_075_181,
       error: nil
     }} =
      Contract.simulate_invoke(
        server,
        network_passphrase,
        contract_address,
        source_public,
        function_name
      )
  end

  test "upload/4", %{
    server: server,
    network_passphrase: network_passphrase,
    wasm: wasm,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.upload(
        server,
        network_passphrase,
        wasm,
        source_secret
      )
  end

  test "deploy/4", %{
    server: server,
    network_passphrase: network_passphrase,
    wasm_id: wasm_id,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.deploy(
        server,
        network_passphrase,
        wasm_id,
        source_secret
      )
  end

  test "deploy_asset/5", %{
    server: server,
    network_passphrase: network_passphrase,
    asset_code: asset_code,
    source_secret: source_secret,
    source_public: source_public
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.deploy_asset(
        server,
        network_passphrase,
        asset_code,
        source_public,
        source_secret
      )
  end

  test "extend_contract/5", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_extend: ledgers_to_extend
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.extend_contract(
        server,
        network_passphrase,
        contract_address,
        source_secret,
        ledgers_to_extend
      )
  end

  test "extend_contract_wasm/5", %{
    server: server,
    network_passphrase: network_passphrase,
    extend_wasm_id: extend_wasm_id,
    source_secret: source_secret,
    ledgers_to_extend: ledgers_to_extend
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.extend_contract_wasm(
        server,
        network_passphrase,
        extend_wasm_id,
        source_secret,
        ledgers_to_extend
      )
  end

  test "extend_contract_keys/6", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_secret: source_secret,
    ledgers_to_extend: ledgers_to_extend,
    keys: keys
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.extend_contract_keys(
        server,
        network_passphrase,
        contract_address,
        source_secret,
        ledgers_to_extend,
        keys
      )
  end

  test "restore_contract/4", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.restore_contract(
        server,
        network_passphrase,
        contract_address,
        source_secret
      )
  end

  test "restore_contract_wasm/4", %{
    server: server,
    network_passphrase: network_passphrase,
    extend_wasm_id: extend_wasm_id,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.restore_contract_wasm(
        server,
        network_passphrase,
        extend_wasm_id,
        source_secret
      )
  end

  test "restore_contract_keys/5", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} =
      Contract.restore_contract_keys(
        server,
        network_passphrase,
        contract_address,
        source_secret,
        persistent: ["Persistent"]
      )
  end

  test "retrieve_unsigned_xdr_to_invoke/6", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_public: source_public,
    function_name: function_name,
    function_args: function_args,
    xdr_envelope: xdr_envelope
  } do
    ^xdr_envelope =
      Contract.retrieve_unsigned_xdr_to_invoke(
        server,
        network_passphrase,
        contract_address,
        source_public,
        function_name,
        function_args
      )
  end

  test "retrieve_unsigned_xdr_to_invoke/5 without args", %{
    server: server,
    network_passphrase: network_passphrase,
    contract_address: contract_address,
    source_public: source_public,
    function_name: function_name,
    no_args_xdr_envelope: no_args_xdr_envelope
  } do
    ^no_args_xdr_envelope =
      Contract.retrieve_unsigned_xdr_to_invoke(
        server,
        network_passphrase,
        contract_address,
        source_public,
        function_name
      )
  end

  test "retrieve_unsigned_xdr_to_upload/4", %{
    server: server,
    network_passphrase: network_passphrase,
    wasm: wasm,
    source_public: source_public,
    upload_xdr_envelope: upload_xdr_envelope
  } do
    ^upload_xdr_envelope =
      Contract.retrieve_unsigned_xdr_to_upload(
        server,
        network_passphrase,
        wasm,
        source_public
      )
  end

  test "retrieve_unsigned_xdr_to_deploy/4", %{
    server: server,
    network_passphrase: network_passphrase,
    wasm_id: wasm_id,
    source_public: source_public
  } do
    assert String.contains?(
             Contract.retrieve_unsigned_xdr_to_deploy(
               server,
               network_passphrase,
               wasm_id,
               source_public
             ),
             "AAAAAgAAAABaOyGfG"
           )
  end

  test "retrieve_unsigned_xdr_to_deploy_asset/4", %{
    server: server,
    network_passphrase: network_passphrase,
    asset_code: asset_code,
    source_public: source_public,
    asset_deploy_xdr_envelope: asset_deploy_xdr_envelope
  } do
    ^asset_deploy_xdr_envelope =
      Contract.retrieve_unsigned_xdr_to_deploy_asset(
        server,
        network_passphrase,
        asset_code,
        source_public
      )
  end
end
