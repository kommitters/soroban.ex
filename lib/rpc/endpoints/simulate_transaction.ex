defmodule Soroban.RPC.SimulateTransaction do
  @moduledoc """
  SimulateTransaction request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{Request, SimulateTransactionResponse}

  @endpoint "simulateTransaction"

  @impl true
  def request(transaction, addlResources \\ nil) do
    params = get_params(transaction, addlResources)

    @endpoint
    |> Request.new()
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.add_params(params)
    |> Request.perform()
    |> Request.results(as: SimulateTransactionResponse)
  end

  defp get_params(transaction, nil), do: %{transaction: transaction}

  defp get_params(transaction, %{cpu_instructions: cpu_instructions}),
    do: %{transaction: transaction, resource_config: %{instruction_leeway: cpu_instructions}}
end
