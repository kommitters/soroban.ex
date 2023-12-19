defmodule Soroban.RPC.SimulateTransactionResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.SimulateTransactionResponse

  setup do
    results = [
      %{
        auth: [
          "AAAAAQAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcAAAAAAAAAAOGr69HGMhJNHrYmkrVICfPPVxkqlKmRGXAskfpmvOyyAAAABGF1dGgAAAACAAAAEwAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcAAAAPAAAABXdvcmxkAAAAAAAAAAAAAAA="
        ],
        xdr: "AAAAEwAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8Bfc="
      }
    ]

    events = [
      "AAAAAQAAAAAAAAAB4avr0cYyEk0etiaStUgJ889XGSqUqZEZcCyR+ma87LIAAAABAAAAAAAAAAEAAAAOAAAABGF1dGgAAAAPAAAABXdvcmxkAAAA",
      "AAAAAQAAAAAAAAAB4avr0cYyEk0etiaStUgJ889XGSqUqZEZcCyR+ma87LIAAAABAAAAAAAAAAEAAAAOAAAABGF1dGgAAAAPAAAABXdvcmxkAAAA"
    ]

    transaction_data =
      "AAAAAwAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcAAAAG4avr0cYyEk0etiaStUgJ889XGSqUqZEZcCyR+ma87LIAAAAUAAAAB8zDhJ3ZTMHmdBjlVh/7d1HDdo+QI1ZXGmeRzBwVAoVXAAAAAQAAAAbhq+vRxjISTR62JpK1SAnzz1cZKpSpkRlwLJH6ZrzssgAAABUAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3ACb/vgAAFcQAAAC0AAABrAAAAAAAAABUAAAAAA=="

    min_resource_fee = "79488"
    cost = %{cpu_insns: "2222468", mem_bytes: "2204681"}
    error_cost = %{cpu_insns: "0", mem_bytes: "0"}

    latest_ledger = 23456
    error = "Could not unmarshal transaction"

    attrs = %{
      transaction_data: transaction_data,
      events: events,
      min_resource_fee: min_resource_fee,
      results: results,
      cost: cost,
      latest_ledger: latest_ledger
    }

    %{
      attrs: attrs,
      result: %{attrs | min_resource_fee: String.to_integer(min_resource_fee)},
      error_result: %{cost: error_cost, latest_ledger: 0, error: error}
    }
  end

  describe "new/1" do
    test "when successful transaction", %{
      result: %{
        transaction_data: transaction_data,
        events: events,
        min_resource_fee: min_resource_fee,
        results: results,
        cost: cost,
        latest_ledger: latest_ledger
      },
      attrs: attrs
    } do
      %SimulateTransactionResponse{
        transaction_data: ^transaction_data,
        events: ^events,
        min_resource_fee: ^min_resource_fee,
        results: ^results,
        cost: ^cost,
        latest_ledger: ^latest_ledger
      } = SimulateTransactionResponse.new(attrs)
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
