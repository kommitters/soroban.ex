defmodule Soroban.RPC.SendTransaction do
  @moduledoc """
  SendTransaction request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{Request, SendTransactionResponse}

  @endpoint "sendTransaction"

  @impl true
  def request(server, transaction) do
    server
    |> Request.new(@endpoint)
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.add_params(%{transaction: transaction})
    |> Request.perform()
    |> Request.results(as: SendTransactionResponse)
  end
end
