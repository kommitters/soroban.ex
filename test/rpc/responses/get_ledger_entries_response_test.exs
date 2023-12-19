defmodule Soroban.RPC.GetLedgerEntriesResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.GetLedgerEntriesResponse

  setup do
    %{
      result: %{
        entries: [
          %{
            key: "AAAAB+qfy4GuVKKfazvyk4R9P9fpo2n9HICsr+xqvVcTF+DC",
            xdr: "AAAABwAAAADqn8uBrlSin2s78pOEfT/X6aNp/RyArK/sar1XExfgwgAAAAphIGNvbnRyYWN0AAA=",
            last_modified_ledger_seq: 2_552_504,
            live_until_ledger_seq: 2_552_504
          }
        ],
        latest_ledger: 45_075_181
      }
    }
  end

  describe "new/1" do
    test "when successful transaction", %{
      result:
        %{
          entries: entries,
          latest_ledger: latest_ledger
        } = result
    } do
      %GetLedgerEntriesResponse{
        entries: ^entries,
        latest_ledger: ^latest_ledger
      } = GetLedgerEntriesResponse.new(result)
    end
  end
end
