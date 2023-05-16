defmodule Soroban.RPC.GetLedgerEntry do
  @moduledoc """
  GetLedgerEntry request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{GetLedgerEntryResponse, Request}

  @endpoint "getLedgerEntry"

  @impl true
  def request(key) do
    @endpoint
    |> Request.new()
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.add_params(%{key: key})
    |> Request.perform()
    |> Request.results(as: GetLedgerEntryResponse)
  end
end
