defmodule Soroban.RPC.GetEventsResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.GetEventsResponse

  setup do
    %{
      result: %{
        latest_ledger: "669450",
        events: [
          %{
            contract_id: "6e34123e6328b38075f4e670175221452db7535ceeb3def1af6dddc232c1eae4",
            id: "0002832986198249472-0000000000",
            in_successful_contract_call: true,
            ledger: "659606",
            ledger_closed_at: "2023-05-15T01:14:16Z",
            paging_token: "0002832986198249472-0000000000",
            topic: [
              "AAAADwAAABJpbmNyZWFzZV9hbGxvd2FuY2UAAA==",
              "AAAADQAAACAdXb1FrxdpSZid+qO1A9Tjp8uLLVm2sJC6FVkryKzTzA==",
              "AAAADQAAACAkFJYqmFNRq105Be9nig3djZQbhSlbzooNAPXeRKcf0w==",
              "AAAADQAAACAKDE4uoS6EI6aSc1it2t042bw51hbj8DhRp245ZZx5Hw=="
            ],
            type: "contract",
            value: "AAAAAwAAAAE="
          }
        ]
      }
    }
  end

  describe "new/1" do
    test "when successful transaction", %{result: result} do
      %GetEventsResponse{
        latest_ledger: "669450",
        events: [
          %{
            contract_id: "6e34123e6328b38075f4e670175221452db7535ceeb3def1af6dddc232c1eae4",
            id: "0002832986198249472-0000000000",
            in_successful_contract_call: true,
            ledger: "659606",
            ledger_closed_at: "2023-05-15T01:14:16Z",
            paging_token: "0002832986198249472-0000000000",
            topic: [
              "AAAADwAAABJpbmNyZWFzZV9hbGxvd2FuY2UAAA==",
              "AAAADQAAACAdXb1FrxdpSZid+qO1A9Tjp8uLLVm2sJC6FVkryKzTzA==",
              "AAAADQAAACAkFJYqmFNRq105Be9nig3djZQbhSlbzooNAPXeRKcf0w==",
              "AAAADQAAACAKDE4uoS6EI6aSc1it2t042bw51hbj8DhRp245ZZx5Hw=="
            ],
            type: "contract",
            value: "AAAAAwAAAAE="
          }
        ]
      } = GetEventsResponse.new(result)
    end
  end
end
