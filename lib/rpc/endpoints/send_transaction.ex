defmodule Soroban.RPC.SendTransaction do
  @moduledoc """
  To perform a request to SendTransaction endpoint for Soroban.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{Request, SendTransactionResponse}

  @endpoint "sendTransaction"

  @impl true
  def request(transaction) do
    @endpoint
    |> Request.new()
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.add_params(%{transaction: transaction})
    |> Request.perform()
    |> Request.results(as: SendTransactionResponse)
  end
end
