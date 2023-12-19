defmodule Soroban.RPC.SimulateTransaction do
  @moduledoc """
  SimulateTransaction request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{Request, SimulateTransactionResponse}

  @endpoint "simulateTransaction"

  @impl true
  def request(transaction, addl_resources \\ nil) do
    params = get_params(transaction, addl_resources)

    @endpoint
    |> Request.new()
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.add_params(params)
    |> Request.perform()
    |> Request.results(as: SimulateTransactionResponse)
  end

  defp get_params(transaction, nil), do: %{transaction: transaction}

  defp get_params(transaction, %{cpu_instructions: cpu_instructions}),
    do: %{transaction: transaction, resourceConfig: %{instructionLeeway: cpu_instructions}}
end
