defmodule Soroban.RPC.CannedRPCSendTransactionClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
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

defmodule Soroban.RPC.CannedRPCSimulateTransactionClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
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
end

defmodule Soroban.RPC.CannedRPCGetHealthClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       status: "healthy"
     }}
  end
end

defmodule Soroban.RPC.CannedRPCGetLatestLedgerClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       id: "2a00000000000000000000000000000000000000000000000000000000000000",
       protocol_version: 20,
       sequence: 666
     }}
  end
end

defmodule Soroban.RPC.CannedRPCGetNetworkClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       friendbot_url: "https://friendbot-futurenet.stellar.org/",
       passphrase: "Test SDF Future Network ; October 2022",
       protocol_version: "20"
     }}
  end
end

defmodule Soroban.RPC.CannedRPCGetLedgerEntriesClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       entries: [
         %{
           key: "AAAAB+qfy4GuVKKfazvyk4R9P9fpo2n9HICsr+xqvVcTF+DC",
           xdr: "AAAABwAAAADqn8uBrlSin2s78pOEfT/X6aNp/RyArK/sar1XExfgwgAAAAphIGNvbnRyYWN0AAA=",
           last_modified_ledger_seq: "13"
         }
       ],
       latest_ledger: "179436"
     }}
  end
end

defmodule Soroban.RPC.CannedRPCGetEventsClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       latest_ledger: "685196",
       events: [
         %{
           contract_id: "CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN",
           id: "0002917807507378176-0000000000",
           in_successful_contract_call: true,
           ledger: "679355",
           ledger_closed_at: "2023-05-16T06:02:47Z",
           paging_token: "0002917807507378176-0000000000",
           topic: [
             "AAAADwAAAAh0cmFuc2Zlcg==",
             "AAAAEwAAAAAAAAAAVAw2XIf/C6hPQZ2EgaY6R7RKuLfchP7836ZvBjZxdVY=",
             "AAAAEwAAAAG2UFHmWnQeBKU73RLX7AQKCktEUE/F/bKqVy+ejoC/YQ==",
             "AAAADQAAACVVU0RDOl3dfLGIo7lPPO+E0KPPSVxWCQ1qOen8umo/g+Jx8baEAAAA"
           ],
           type: "contract",
           value: "AAAACgAAAAAF9eEAAAAAAAAAAAA="
         }
       ]
     }}
  end
end

defmodule Soroban.RPC.CannedRPCGetTransactionClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       status: "SUCCESS",
       latest_ledger: "476536",
       latest_ledger_close_time: "1683151229",
       oldest_ledger: "475097",
       oldest_ledger_close_time: "1683143656",
       application_order: 1,
       envelope_xdr:
         "AAAAAgAAAADBPp7TMinJylnn+6dQXJACNc15LF+aJ2Py1BaR4P10JAAAAGQAAFBfAAAAIQAAAAEAAAAAAAAAAAAAAABkUtg3AAAAAAAAAAEAAAABAAAAAME+ntMyKcnKWef7p1BckAI1zXksX5onY/LUFpHg/XQkAAAAGAAAAAAAAAADAAAADQAAACAU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAAA8AAAAFaGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAAAAAAAAAAAAAAAAAB4P10JAAAAEDS4+hvSG1JqhOIPaGSqUerNsjhIcS+AwWhH/K8IOafcmMlZJoyZvMftV1QcdWA/LQhr2QJRTWNT6I52/eTP3IH",
       result_xdr:
         "AAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAYAAAAAAAAABAAAAABAAAAAgAAAA8AAAAFSGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAA==",
       result_meta_xdr:
         "AAAAAwAAAAIAAAADAAdFBQAAAAAAAAAAwT6e0zIpycpZ5/unUFyQAjXNeSxfmidj8tQWkeD9dCQAAAAXDNwRHAAAUF8AAAAgAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAwAAAAAAB0J+AAAAAGRSydYAAAAAAAAAAQAHRQUAAAAAAAAAAME+ntMyKcnKWef7p1BckAI1zXksX5onY/LUFpHg/XQkAAAAFwzcERwAAFBfAAAAIQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAAdFBQAAAABkUtcZAAAAAAAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAYAAAAAAAAABAAAAABAAAAAgAAAA8AAAAFSGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAKQ1a84I/mDKy5j2B/YFeyfTCsTBoKJtON5QDfqS06qwy7xIdQ3ruFNQk7Per4isf0z/h0JVdqWN4rrHVKzbRhYD6NIFNZRcltVrmGLx9Y+ku182sxlHjDdsZ28pYul9HwAAAAA=",
       ledger: "476421"
     }}
  end
end

defmodule Soroban.RPCTest do
  use ExUnit.Case

  alias Soroban.RPC

  alias Soroban.RPC.{
    CannedRPCGetEventsClientImpl,
    CannedRPCGetHealthClientImpl,
    CannedRPCGetLatestLedgerClientImpl,
    CannedRPCGetLedgerEntriesClientImpl,
    CannedRPCGetNetworkClientImpl,
    CannedRPCGetTransactionClientImpl,
    CannedRPCSendTransactionClientImpl,
    CannedRPCSimulateTransactionClientImpl,
    EventFilter,
    EventsPayload,
    GetEventsResponse,
    GetHealthResponse,
    GetLatestLedgerResponse,
    GetLedgerEntriesResponse,
    GetNetworkResponse,
    GetTransactionResponse,
    SendTransactionResponse,
    SimulateTransactionResponse,
    TopicFilter
  }

  alias Soroban.Types.Symbol

  describe "simulate_transaction/1" do
    setup do
      Application.put_env(:soroban, :http_client_impl, CannedRPCSimulateTransactionClientImpl)

      on_exit(fn ->
        Application.delete_env(:soroban, :http_client_impl)
      end)

      base64_envelope =
        "AAAAAgAAAADWKIRtrzg/aTCtUHeZnpyYu0iNxJxcn4tr0jXG2hOIlwAAAGQABzbWAAAAAwAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAGAAAAAAAAAAEAAAADQAAACC8xDySpTRgcsckFZY9QBvIP3LL70Jp0xG3cmpCvp0d/QAAAA8AAAAJaW5jcmVtZW50AAAAAAAAEwAAAAAAAAAA1iiEba84P2kwrVB3mZ6cmLtIjcScXJ+La9I1xtoTiJcAAAADAAAACgAAAAAAAAAAAAAAAQAAAAC8xDySpTRgcsckFZY9QBvIP3LL70Jp0xG3cmpCvp0d/QAAAAlpbmNyZW1lbnQAAAAAAAACAAAAEwAAAAAAAAAA1iiEba84P2kwrVB3mZ6cmLtIjcScXJ+La9I1xtoTiJcAAAADAAAACgAAAAAAAAAAAAAAAAAAAAA="

      %{base64_envelope: base64_envelope}
    end

    test "returns the respective response", %{base64_envelope: base64_envelope} do
      {:ok,
       %SimulateTransactionResponse{
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
         latest_ledger: "475528",
         error: nil
       }} = RPC.simulate_transaction(base64_envelope)
    end
  end

  describe "send_transaction/1" do
    setup do
      Application.put_env(:soroban, :http_client_impl, CannedRPCSendTransactionClientImpl)

      on_exit(fn ->
        Application.delete_env(:soroban, :http_client_impl)
      end)

      base64_envelope =
        "AAAAAgAAAADBPp7TMinJylnn+6dQXJACNc15LF+aJ2Py1BaR4P10JAAAAGQAAFBfAAAAIQAAAAEAAAAAAAAAAAAAAABkUtg3AAAAAAAAAAEAAAABAAAAAME+ntMyKcnKWef7p1BckAI1zXksX5onY/LUFpHg/XQkAAAAGAAAAAAAAAADAAAADQAAACAU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAAA8AAAAFaGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAAAAAAAAAAAAAAAAAB4P10JAAAAEDS4+hvSG1JqhOIPaGSqUerNsjhIcS+AwWhH/K8IOafcmMlZJoyZvMftV1QcdWA/LQhr2QJRTWNT6I52/eTP3IH"

      %{base64_envelope: base64_envelope}
    end

    test "returns the respective response", %{base64_envelope: base64_envelope} do
      {:ok,
       %SendTransactionResponse{
         status: "PENDING",
         hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
         latest_ledger: "476420",
         latest_ledger_close_time: "1683150612",
         error_result_xdr: nil
       }} = RPC.send_transaction(base64_envelope)
    end
  end

  describe "get_transaction/1" do
    setup do
      Application.put_env(:soroban, :http_client_impl, CannedRPCGetTransactionClientImpl)

      on_exit(fn ->
        Application.delete_env(:soroban, :http_client_impl)
      end)

      hash = "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4"

      %{hash: hash}
    end

    test "request/1", %{hash: hash} do
      {:ok,
       %GetTransactionResponse{
         status: "SUCCESS",
         latest_ledger: "476536",
         latest_ledger_close_time: "1683151229",
         oldest_ledger: "475097",
         oldest_ledger_close_time: "1683143656",
         application_order: 1,
         envelope_xdr:
           "AAAAAgAAAADBPp7TMinJylnn+6dQXJACNc15LF+aJ2Py1BaR4P10JAAAAGQAAFBfAAAAIQAAAAEAAAAAAAAAAAAAAABkUtg3AAAAAAAAAAEAAAABAAAAAME+ntMyKcnKWef7p1BckAI1zXksX5onY/LUFpHg/XQkAAAAGAAAAAAAAAADAAAADQAAACAU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAAA8AAAAFaGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAAAAAAAAAAAAAAAAAB4P10JAAAAEDS4+hvSG1JqhOIPaGSqUerNsjhIcS+AwWhH/K8IOafcmMlZJoyZvMftV1QcdWA/LQhr2QJRTWNT6I52/eTP3IH",
         result_xdr:
           "AAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAYAAAAAAAAABAAAAABAAAAAgAAAA8AAAAFSGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAA==",
         result_meta_xdr:
           "AAAAAwAAAAIAAAADAAdFBQAAAAAAAAAAwT6e0zIpycpZ5/unUFyQAjXNeSxfmidj8tQWkeD9dCQAAAAXDNwRHAAAUF8AAAAgAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAwAAAAAAB0J+AAAAAGRSydYAAAAAAAAAAQAHRQUAAAAAAAAAAME+ntMyKcnKWef7p1BckAI1zXksX5onY/LUFpHg/XQkAAAAFwzcERwAAFBfAAAAIQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAAdFBQAAAABkUtcZAAAAAAAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAYAAAAAAAAABAAAAABAAAAAgAAAA8AAAAFSGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAKQ1a84I/mDKy5j2B/YFeyfTCsTBoKJtON5QDfqS06qwy7xIdQ3ruFNQk7Per4isf0z/h0JVdqWN4rrHVKzbRhYD6NIFNZRcltVrmGLx9Y+ku182sxlHjDdsZ28pYul9HwAAAAA=",
         ledger: "476421"
       }} = RPC.get_transaction(hash)
    end
  end

  describe "get_health/0" do
    setup do
      Application.put_env(:soroban, :http_client_impl, CannedRPCGetHealthClientImpl)

      on_exit(fn ->
        Application.delete_env(:soroban, :http_client_impl)
      end)
    end

    test "request/0" do
      {:ok, %GetHealthResponse{status: "healthy"}} = RPC.get_health()
    end
  end

  describe "get_latest_ledger/0" do
    setup do
      Application.put_env(:soroban, :http_client_impl, CannedRPCGetLatestLedgerClientImpl)

      on_exit(fn ->
        Application.delete_env(:soroban, :http_client_impl)
      end)
    end

    test "request/0" do
      {:ok,
       %GetLatestLedgerResponse{
         id: "2a00000000000000000000000000000000000000000000000000000000000000",
         protocol_version: 20,
         sequence: 666
       }} = RPC.get_latest_ledger()
    end
  end

  describe "get_network/0" do
    setup do
      Application.put_env(:soroban, :http_client_impl, CannedRPCGetNetworkClientImpl)

      on_exit(fn ->
        Application.delete_env(:soroban, :http_client_impl)
      end)
    end

    test "request/0" do
      {:ok,
       %GetNetworkResponse{
         friendbot_url: "https://friendbot-futurenet.stellar.org/",
         passphrase: "Test SDF Future Network ; October 2022",
         protocol_version: "20"
       }} = RPC.get_network()
    end
  end

  describe "get_ledger_entries/1" do
    setup do
      Application.put_env(:soroban, :http_client_impl, CannedRPCGetLedgerEntriesClientImpl)

      on_exit(fn ->
        Application.delete_env(:soroban, :http_client_impl)
      end)

      %{keys: ["AAAABhv6ziOnWcVRdGMZjtFKSWnLSndMp9JPVLLXxQqAvKqJAAAABQAAAAdDT1VOVEVSAA"]}
    end

    test "request/1", %{keys: keys} do
      {:ok,
       %GetLedgerEntriesResponse{
         entries: [
           %{
             key: "AAAAB+qfy4GuVKKfazvyk4R9P9fpo2n9HICsr+xqvVcTF+DC",
             xdr: "AAAABwAAAADqn8uBrlSin2s78pOEfT/X6aNp/RyArK/sar1XExfgwgAAAAphIGNvbnRyYWN0AAA=",
             last_modified_ledger_seq: "13"
           }
         ],
         latest_ledger: "179436"
       }} = RPC.get_ledger_entries(keys)
    end
  end

  describe "get_events/1" do
    setup do
      Application.put_env(:soroban, :http_client_impl, CannedRPCGetEventsClientImpl)

      on_exit(fn ->
        Application.delete_env(:soroban, :http_client_impl)
      end)

      limit = 1
      start_ledger = "674736"
      args = [Symbol.new("transfer"), "*", "*", "*"]
      topic_filter = [TopicFilter.new(args)]
      contract_ids = ["CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN"]

      filters = [
        EventFilter.new(type: [:contract], contract_ids: contract_ids, topics: topic_filter)
      ]

      event =
        EventsPayload.new(
          start_ledger: start_ledger,
          filters: filters,
          limit: limit
        )

      %{event: event}
    end

    test "request/1", %{event: event} do
      {:ok,
       %GetEventsResponse{
         latest_ledger: "685196",
         events: [
           %{
             contract_id: "CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN",
             id: "0002917807507378176-0000000000",
             in_successful_contract_call: true,
             ledger: "679355",
             ledger_closed_at: "2023-05-16T06:02:47Z",
             paging_token: "0002917807507378176-0000000000",
             topic: [
               "AAAADwAAAAh0cmFuc2Zlcg==",
               "AAAAEwAAAAAAAAAAVAw2XIf/C6hPQZ2EgaY6R7RKuLfchP7836ZvBjZxdVY=",
               "AAAAEwAAAAG2UFHmWnQeBKU73RLX7AQKCktEUE/F/bKqVy+ejoC/YQ==",
               "AAAADQAAACVVU0RDOl3dfLGIo7lPPO+E0KPPSVxWCQ1qOen8umo/g+Jx8baEAAAA"
             ],
             type: "contract",
             value: "AAAACgAAAAAF9eEAAAAAAAAAAAA="
           }
         ]
       }} = RPC.get_events(event)
    end
  end
end
