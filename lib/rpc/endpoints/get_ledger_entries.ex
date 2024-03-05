defmodule Soroban.RPC.GetLedgerEntries do
  @moduledoc """
  GetLedgerEntries request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{GetLedgerEntriesResponse, Request}

  @endpoint "getLedgerEntries"

  @impl true
  def request(server, keys) do
    server
    |> Request.new(@endpoint)
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.add_params(%{keys: keys})
    |> Request.perform()
    |> Request.results(as: GetLedgerEntriesResponse)
  end
end
