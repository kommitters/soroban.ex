defmodule Soroban.RPC.GetLatestLedger do
  @moduledoc """
  GetLatestLedger request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{GetLatestLedgerResponse, Request}

  @endpoint "getLatestLedger"

  @impl true
  def request(_params \\ nil) do
    @endpoint
    |> Request.new()
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.perform()
    |> Request.results(as: GetLatestLedgerResponse)
  end
end
