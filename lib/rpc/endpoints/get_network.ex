defmodule Soroban.RPC.GetNetwork do
  @moduledoc """
  GetNetwork request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{GetNetworkResponse, Request}

  @endpoint "getNetwork"

  @impl true
  def request(server, _params \\ nil) do
    server
    |> Request.new(@endpoint)
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.perform()
    |> Request.results(as: GetNetworkResponse)
  end
end
