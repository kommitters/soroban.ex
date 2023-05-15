defmodule Soroban.RPC.GetHealthResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.GetHealthResponse

  setup do
    %{
      result: %{
        status: "healthy"
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
