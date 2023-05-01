defmodule Soroban.RPC.Responses.SimulateTransactionResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.Responses.SimulateTransactionResponse

  setup do
    results = [
      %{
        auth: "... TODO: Generate a plausible xdr.ContractAuth ...",
        footprint:
          "AAAAAgAAAAYb+s4jp1nFUXRjGY7RSklpy0p3TKfST1Sy18UKgLyqiQAAAAMAAAADAAAAB9QqWUc9AUjduz5qrbJgYb/gACScB4Jq7yTT6x0QJfZfAAAAAQAAAAYb+s4jp1nFUXRjGY7RSklpy0p3TKfST1Sy18UKgLyqiQAAAAUAAAAHQ09VTlRFUgA=",
        xdr: "AAAAAQAAAAY="
      }
    ]

    cost = %{cpu_insns: "163642", mem_bytes: "1506"}
    error_cost = %{cpu_insns: "0", mem_bytes: "0"}

    latest_ledger = "230473"
    error = "Could not unmarshal transaction"

    %{
      result: %{results: results, cost: cost, latest_ledger: latest_ledger},
      error_result: %{cost: error_cost, latest_ledger: "0", error: error}
    }
  end

  describe "new/1" do
    test "when successful transaction", %{
      result: %{results: results, cost: cost, latest_ledger: latest_ledger} = result
    } do
      %SimulateTransactionResponse{
        results: ^results,
        cost: ^cost,
        latest_ledger: ^latest_ledger
      } = SimulateTransactionResponse.new(result)
    end

    test "when error transaction", %{
      error_result: %{error: error, cost: cost, latest_ledger: latest_ledger} = error_result
    } do
      %SimulateTransactionResponse{
        error: ^error,
        cost: ^cost,
        latest_ledger: ^latest_ledger
      } = SimulateTransactionResponse.new(error_result)
    end
  end
end
