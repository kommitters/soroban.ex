defmodule Soroban.RPC.TopicFilterTest do
  use ExUnit.Case

  alias Soroban.RPC.TopicFilter
  alias Soroban.Types.Symbol

  setup do
    args = [Symbol.new("increase_allowance"), "*", "*", "*"]
    segments = ["AAAADwAAABJpbmNyZWFzZV9hbGxvd2FuY2UAAA==", "*", "*", "*"]
    topic_filter = TopicFilter.new(args)
    %{args: args, segments: segments, topic_filter: topic_filter}
  end

  describe "new/1" do
    test "with a valid value", %{args: args, segments: segments} do
      %TopicFilter{segments: ^segments} = TopicFilter.new(args)
    end

    test "with invalid args" do
      {:error, :invalid_args} = TopicFilter.new("Invalid")
    end

    test "with invalid value" do
      {:error, :invalid_segments} = TopicFilter.new(["invalid"])
    end
  end

  describe "to_request_args/1" do
    test "with a valid struct", %{topic_filter: topic_filter, segments: segments} do
      ^segments = TopicFilter.to_request_args(topic_filter)
    end

    test "with an invalid value" do
      :error = TopicFilter.to_request_args(nil)
    end
  end
end
