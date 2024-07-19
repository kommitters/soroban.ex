defmodule Soroban.RPC.GetFeeStats do
  @moduledoc """
  GetFeeStats request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{GetFeeStatsResponse, Request}

  @endpoint "getFeeStats"

  @impl true
  def request(server, _params \\ nil) do
    server
    |> Request.new(@endpoint)
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.perform()
    |> Request.results(as: GetFeeStatsResponse)
  end
end
