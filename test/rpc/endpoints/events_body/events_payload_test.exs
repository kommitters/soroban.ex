defmodule Soroban.RPC.EventsPayloadTest do
  use ExUnit.Case

  alias Soroban.RPC.{EventFilter, EventsPayload, TopicFilter}
  alias Soroban.Types.Symbol

  setup do
    cursor = "1234-1"
    limit = 2
    start_ledger = "674736"
    args = [Symbol.new("transfer"), "*", "*", "*"]
    topic_filter = [TopicFilter.new(args)]
    contract_ids = ["7d9defe0ccf9b680014a343b8880c22b160c2ea2c9a69df876decb28ddbd03dc"]

    filters = [
      EventFilter.new(type: [:contract], contract_ids: contract_ids, topics: topic_filter)
    ]

    event =
      EventsPayload.new(
        start_ledger: start_ledger,
        filters: filters,
        cursor: cursor,
        limit: limit
      )

    %{
      start_ledger: start_ledger,
      event: event,
      filters: filters,
      cursor: cursor,
      limit: limit,
      invalid_filters: filters ++ [Symbol.new("increase_allowance")]
    }
  end

  describe "new/1" do
    test "with valid values", %{
      start_ledger: start_ledger,
      filters: filters,
      cursor: cursor,
      limit: limit
    } do
      %EventsPayload{
        start_ledger: ^start_ledger,
        filters: ^filters,
        pagination: %{cursor: ^cursor, limit: ^limit}
      } =
        EventsPayload.new(
          start_ledger: start_ledger,
          filters: filters,
          cursor: cursor,
          limit: limit
        )
    end

    test "with nil values", %{start_ledger: start_ledger} do
      %EventsPayload{
        start_ledger: ^start_ledger,
        filters: nil,
        pagination: %{cursor: nil, limit: nil}
      } = EventsPayload.new(start_ledger: start_ledger)
    end

    test "with invalid args" do
      {:error, :invalid_args} = EventsPayload.new("Invalid")
    end

    test "with an invalid start_ledger" do
      {:error, :invalid_start_ledger} = EventsPayload.new(start_ledger: :invalid)
    end

    test "with invalid filters", %{start_ledger: start_ledger} do
      {:error, :invalid_filters} =
        EventsPayload.new(start_ledger: start_ledger, filters: :invalid_filters)
    end

    test "with invalid filter in list", %{
      start_ledger: start_ledger,
      invalid_filters: invalid_filters
    } do
      {:error, :invalid_filters} =
        EventsPayload.new(start_ledger: start_ledger, filters: invalid_filters)
    end

    test "with an invalid cursor", %{limit: limit} do
      {:error, :invalid_cursor} = EventsPayload.new(cursor: 10, limit: limit)
    end

    test "with an invalid limit", %{cursor: cursor} do
      {:error, :invalid_limit} = EventsPayload.new(cursor: cursor, limit: "invalid")
    end
  end

  describe "to_request_args/1" do
    test "with a valid struct", %{
      event: event,
      start_ledger: start_ledger,
      limit: limit,
      cursor: cursor
    } do
      %{
        startLedger: ^start_ledger,
        filters: [
          %{
            contractIds: ["7d9defe0ccf9b680014a343b8880c22b160c2ea2c9a69df876decb28ddbd03dc"],
            topics: [["AAAADwAAAAh0cmFuc2Zlcg==", "*", "*", "*"]],
            type: "contract"
          }
        ],
        pagination: %{cursor: ^cursor, limit: ^limit}
      } = EventsPayload.to_request_args(event)
    end

    test "with an invalid struct" do
      :error = EventsPayload.to_request_args(nil)
    end
  end
end
