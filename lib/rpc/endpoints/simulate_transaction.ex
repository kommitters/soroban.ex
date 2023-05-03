defmodule Soroban.RPC.SimulateTransaction do
  @moduledoc """
  To perform a request to SimulateTransaction endpoint for Soroban.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{Request, SimulateTransactionResponse}

  @type transaction :: String.t()
  @type response :: tuple()

  @impl true
  def request(transaction) do
    "simulateTransaction"
    |> Request.new()
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.add_params(%{transaction: transaction})
    |> Request.perform()
    |> Request.results(as: SimulateTransactionResponse)
  end
end
