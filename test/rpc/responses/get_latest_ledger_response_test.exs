defmodule Soroban.RPC.GetLatestLedgerResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.GetLatestLedgerResponse

  setup do
    %{
      result: %{
        id: "2a00000000000000000000000000000000000000000000000000000000000000",
        protocol_version: 20,
        sequence: 666
      }
    }
  end

  describe "new/1" do
    test "when successful transaction", %{
      result: %{id: id, protocol_version: protocol_version, sequence: sequence} = result
    } do
      %GetLatestLedgerResponse{
        id: ^id,
        protocol_version: ^protocol_version,
        sequence: ^sequence
      } = GetLatestLedgerResponse.new(result)
    end
  end
end
