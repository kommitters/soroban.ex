defmodule Soroban.RPC.GetFeeStatsResponseTest do
  use ExUnit.Case
  alias Soroban.RPC.GetFeeStatsResponse

  setup do
    %{
      result: %{
        soroban_inclusion_fee: %{
          max: "100",
          min: "100",
          mode: "100",
          p10: "100",
          p20: "100",
          p30: "100",
          p40: "100",
          p50: "100",
          p60: "100",
          p70: "100",
          p80: "100",
          p90: "100",
          p95: "100",
          p99: "100",
          transaction_count: "7",
          ledger_count: 50
        },
        inclusion_fee: %{
          max: "200",
          min: "100",
          mode: "200",
          p10: "100",
          p20: "100",
          p30: "100",
          p40: "150",
          p50: "200",
          p60: "200",
          p70: "200",
          p80: "200",
          p90: "200",
          p95: "200",
          p99: "200",
          transaction_count: "27",
          ledger_count: 10
        },
        latest_ledger: 619_731
      }
    }
  end

  describe "new/1" do
    test "when successful transaction", %{
      result: result
    } do
      %GetFeeStatsResponse{
        soroban_inclusion_fee: %{
          max: "100",
          min: "100",
          mode: "100",
          p10: "100",
          p20: "100",
          p30: "100",
          p40: "100",
          p50: "100",
          p60: "100",
          p70: "100",
          p80: "100",
          p90: "100",
          p95: "100",
          p99: "100",
          transaction_count: "7",
          ledger_count: 50
        },
        inclusion_fee: %{
          max: "200",
          min: "100",
          mode: "200",
          p10: "100",
          p20: "100",
          p30: "100",
          p40: "150",
          p50: "200",
          p60: "200",
          p70: "200",
          p80: "200",
          p90: "200",
          p95: "200",
          p99: "200",
          transaction_count: "27",
          ledger_count: 10
        },
        latest_ledger: 619_731
      } = GetFeeStatsResponse.new(result)
    end
  end
end
