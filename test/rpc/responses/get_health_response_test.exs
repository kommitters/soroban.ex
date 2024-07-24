defmodule Soroban.RPC.GetHealthResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.GetHealthResponse

  setup do
    %{
      result: %{
        status: "healthy",
        latest_ledger: 706_073,
        oldest_ledger: 688_794,
        ledger_retention_window: 17_280
      }
    }
  end

  describe "new/1" do
    test "when successful transaction", %{result: %{status: status} = result} do
      %GetHealthResponse{
        status: ^status
      } = GetHealthResponse.new(result)
    end
  end
end
