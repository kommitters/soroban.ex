defmodule Soroban.RPC.SendTransactionResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.SendTransactionResponse

  setup do
    pending_response = %{
      hash: "d70916f8b8aa55c13d5974a38e32a3efe440ef6870c0f0a07075d1c128d23698",
      status: "PENDING",
      latest_ledger: 45_075_181,
      latest_ledger_close_time: "1677115742",
      error_result_xdr: nil,
      diagnostic_events_xdr: nil
    }

    error_response = %{
      pending_response
      | status: "ERROR",
        error_result_xdr: "AAAAAAAAAGT////7AAAAAA==",
        diagnostic_events_xdr: [
          "AAAAAQAAAAAAAAAAAAAAAgAAAAAAAAADAAAADwAAAAdmbl9jYWxsAAAAAA0AAAAgr/p6gt6h8MrmSw+WNJnu3+sCP9dHXx7jR8IH0sG6Cy0AAAAPAAAABWhlbGxvAAAAAAAADwAAAAVBbG9oYQAAAA=="
        ]
    }

    %{
      pending_response: pending_response,
      error_response: error_response
    }
  end

  describe "new/1" do
    test "when pending response", %{
      pending_response:
        %{
          hash: hash,
          status: status,
          latest_ledger: latest_ledger,
          latest_ledger_close_time: latest_ledger_close_time,
          error_result_xdr: error_result_xdr,
          diagnostic_events_xdr: diagnostic_events_xdr
        } = pending_response
    } do
      %SendTransactionResponse{
        hash: ^hash,
        status: ^status,
        latest_ledger: ^latest_ledger,
        latest_ledger_close_time: ^latest_ledger_close_time,
        error_result_xdr: ^error_result_xdr,
        diagnostic_events_xdr: ^diagnostic_events_xdr
      } = SendTransactionResponse.new(pending_response)
    end

    test "when error response", %{
      error_response:
        %{
          hash: hash,
          status: status,
          latest_ledger: latest_ledger,
          latest_ledger_close_time: latest_ledger_close_time,
          error_result_xdr: error_result_xdr,
          diagnostic_events_xdr: diagnostic_events_xdr
        } = error_response
    } do
      %SendTransactionResponse{
        hash: ^hash,
        status: ^status,
        latest_ledger: ^latest_ledger,
        latest_ledger_close_time: ^latest_ledger_close_time,
        error_result_xdr: ^error_result_xdr,
        diagnostic_events_xdr: ^diagnostic_events_xdr
      } = SendTransactionResponse.new(error_response)
    end
  end
end
