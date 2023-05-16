defmodule Soroban.RPC.CannedGetEventsClientImpl do
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
           contract_id: "7d9defe0ccf9b680014a343b8880c22b160c2ea2c9a69df876decb28ddbd03dc",
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
           value: %{xdr: "AAAACgAAAAAF9eEAAAAAAAAAAAA="}
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
    EventsBody,
    GetEvents,
    GetEventsResponse,
    TopicFilter
  }

  alias Soroban.Types.Symbol

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedGetEventsClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    limit = 1
    start_ledger = "674736"
    args = [Symbol.new("transfer"), "*", "*", "*"]
    topic_filter = [TopicFilter.new(args)]
    contract_ids = ["7d9defe0ccf9b680014a343b8880c22b160c2ea2c9a69df876decb28ddbd03dc"]

    filters = [
      EventFilter.new(type: [:contract], contract_ids: contract_ids, topics: topic_filter)
    ]

    event =
      EventsBody.new(
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
           contract_id: "7d9defe0ccf9b680014a343b8880c22b160c2ea2c9a69df876decb28ddbd03dc",
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
           value: %{xdr: "AAAACgAAAAAF9eEAAAAAAAAAAAA="}
         }
       ]
     }} = GetEvents.request(event)
  end
end
