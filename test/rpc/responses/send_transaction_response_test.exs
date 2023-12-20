defmodule Soroban.RPC.SendTransactionResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.SendTransactionResponse

  setup do
    result = %{
      hash: "d70916f8b8aa55c13d5974a38e32a3efe440ef6870c0f0a07075d1c128d23698",
      status: :pending,
      latest_ledger: 45_075_181,
      latest_ledger_close_time: "1677115742"
    }

    %{
      result: result,
      error_result:
        Map.merge(result, %{status: :error, error_result_xdr: "AAAAAAAAAGT////7AAAAAA=="})
    }
  end

  describe "new/1" do
    test "when successful response", %{
      result:
        %{
          hash: hash,
          status: status,
          latest_ledger: latest_ledger,
          latest_ledger_close_time: latest_ledger_close_time
        } = result
    } do
      %SendTransactionResponse{
        hash: ^hash,
        status: ^status,
        latest_ledger: ^latest_ledger,
        latest_ledger_close_time: ^latest_ledger_close_time
      } = SendTransactionResponse.new(result)
    end

    test "when error response", %{
      error_result:
        %{
          hash: hash,
          status: status,
          latest_ledger: latest_ledger,
          latest_ledger_close_time: latest_ledger_close_time,
          error_result_xdr: error_result_xdr
        } = result
    } do
      %SendTransactionResponse{
        hash: ^hash,
        status: ^status,
        latest_ledger: ^latest_ledger,
        latest_ledger_close_time: ^latest_ledger_close_time,
        error_result_xdr: ^error_result_xdr
      } = SendTransactionResponse.new(result)
    end
  end
end
