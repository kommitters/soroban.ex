defmodule Soroban.RPC.GetTransaction do
  @moduledoc """
  GetTransaction request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{GetTransactionResponse, Request}

  @endpoint "getTransaction"

  @impl true
  def request(server, hash) do
    server
    |> Request.new(@endpoint)
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.add_params(%{hash: hash})
    |> Request.perform()
    |> Request.results(as: GetTransactionResponse)
  end
end
