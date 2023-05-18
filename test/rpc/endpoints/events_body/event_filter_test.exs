defmodule Soroban.RPC.EventFilterTest do
  use ExUnit.Case

  alias Soroban.RPC.{EventFilter, TopicFilter}
  alias Soroban.Types.Symbol

  setup do
    args = [Symbol.new("increase_allowance"), "*", "*", "*"]
    topic_filter = [TopicFilter.new(args)]
    contract_ids = ["6e34123e6328b38075f4e670175221452db7535ceeb3def1af6dddc232c1eae4"]

    event_filter =
      EventFilter.new(type: [:contract], contract_ids: contract_ids, topics: topic_filter)

    event_filter_without_type = EventFilter.new(contract_ids: contract_ids, topics: topic_filter)

    %{
      type: [:contract],
      contract_ids: contract_ids,
      topic_filter: topic_filter,
      event_filter: event_filter,
      event_filter_without_type: event_filter_without_type
    }
  end

  describe "new/1" do
    test "with valid values", %{
      type: type,
      contract_ids: contract_ids,
      topic_filter: topic_filter
    } do
      %EventFilter{type: ^type, contract_ids: ^contract_ids, topics: ^topic_filter} =
        EventFilter.new(
          type: type,
          contract_ids: contract_ids,
          topics: topic_filter
        )
    end

    test "with nil values" do
      %EventFilter{type: nil, contract_ids: nil, topics: nil} =
        EventFilter.new(
          type: nil,
          contract_ids: nil,
          topics: nil
        )
    end

    test "with invalid args" do
      {:error, :invalid_args} = EventFilter.new("Invalid")
    end

    test "with invalid type" do
      {:error, :invalid_type} = EventFilter.new(type: [:invalid])
    end

    test "with invalid types" do
      {:error, :invalid_types} = EventFilter.new(type: :invalid)
    end

    test "with invalid contract_ids" do
      {:error, :invalid_contract_ids} = EventFilter.new(contract_ids: :invalid)
    end

    test "with invalid contract_ids values" do
      {:error, :invalid_contract_ids} = EventFilter.new(contract_ids: [:invalid])
    end

    test "with invalid topics" do
      {:error, :invalid_topics} = EventFilter.new(topics: [:invalid])
    end
  end

  describe "to_request_args/1" do
    test "with a valid struct", %{
      event_filter: event_filter,
      contract_ids: contract_ids
    } do
      %{
        type: "contract",
        contractIds: ^contract_ids,
        topics: [["AAAADwAAABJpbmNyZWFzZV9hbGxvd2FuY2UAAA==", "*", "*", "*"]]
      } = EventFilter.to_request_args(event_filter)
    end

    test "with a valid struct and type nil", %{
      event_filter_without_type: event_filter_without_type,
      contract_ids: contract_ids
    } do
      %{
        type: nil,
        contractIds: ^contract_ids,
        topics: [["AAAADwAAABJpbmNyZWFzZV9hbGxvd2FuY2UAAA==", "*", "*", "*"]]
      } = EventFilter.to_request_args(event_filter_without_type)
    end

    test "with an invalid value" do
      :error = EventFilter.to_request_args(nil)
    end
  end
end
