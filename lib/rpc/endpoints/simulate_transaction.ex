defmodule Soroban.RPC.SimulateTransaction do
  @moduledoc """
  SimulateTransaction request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{Request, SimulateTransactionResponse}

  @endpoint "simulateTransaction"

  @impl true
  def request(transaction) do
    @endpoint
    |> Request.new()
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.add_params(%{transaction: transaction})
    |> Request.perform()
    |> Request.results(as: SimulateTransactionResponse)
  end
end
