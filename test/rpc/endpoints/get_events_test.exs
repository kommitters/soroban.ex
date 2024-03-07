defmodule Soroban.RPC.CannedGetEventsClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       latest_ledger: 45_075_181,
       events: [
         %{
           contract_id: "CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN",
           id: "0002917807507378176-0000000000",
           in_successful_contract_call: true,
           ledger: 679_355,
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

defmodule Soroban.RPC.GetEventsTest do
  use ExUnit.Case

  alias Soroban.RPC.{
    CannedGetEventsClientImpl,
    EventFilter,
    EventsPayload,
    GetEvents,
    GetEventsResponse,
    Server,
    TopicFilter
  }

  alias Soroban.Types.Symbol

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedGetEventsClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    limit = 1
    start_ledger = 674_736
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

    %{event: event, server: Server.testnet()}
  end

  test "request/1", %{event: event, server: server} do
    {:ok,
     %GetEventsResponse{
       latest_ledger: 45_075_181,
       events: [
         %{
           contract_id: "CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN",
           id: "0002917807507378176-0000000000",
           in_successful_contract_call: true,
           ledger: 679_355,
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
     }} = GetEvents.request(server, event)
  end
end
