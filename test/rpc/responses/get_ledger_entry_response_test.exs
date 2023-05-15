defmodule Soroban.RPC.GetLedgerEntryResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.GetLedgerEntryResponse

  setup do
    %{
      result: %{
        xdr: "AAAABhv6ziOnWcVRdGMZjtFKSWnLSndMp9JPVLLXxQqAvKqJAAAABQAAAAdDT1VOVEVSAAAAAAEAAAAD",
        last_modified_ledger_seq: "164986",
        latest_ledger: "179436"
      }
    }
  end

  describe "new/1" do
    test "when successful transaction", %{
      result:
        %{
          xdr: xdr,
          last_modified_ledger_seq: last_modified_ledger_seq,
          latest_ledger: latest_ledger
        } = result
    } do
      %GetLedgerEntryResponse{
        xdr: ^xdr,
        last_modified_ledger_seq: ^last_modified_ledger_seq,
        latest_ledger: ^latest_ledger
      } = GetLedgerEntryResponse.new(result)
    end
  end
end
