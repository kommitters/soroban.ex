defmodule Soroban.RPC.GetTransactions do
  @moduledoc """
  GetTransactions request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{GetTransactionsResponse, Request, TransactionsPayload}

  @endpoint "getTransactions"

  @impl true
  def request(server, %TransactionsPayload{} = transactions_payload) do
    payload = TransactionsPayload.to_request_args(transactions_payload)

    server
    |> Request.new(@endpoint)
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.add_params(payload)
    |> Request.perform()
    |> Request.results(as: GetTransactionsResponse)
  end
end
