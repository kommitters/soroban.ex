defmodule Soroban.RPC.GetNetwork do
  @moduledoc """
  GetNetwork request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{GetNetworkResponse, Request}

  @endpoint "getNetwork"

  @impl true
  def request(_params \\ nil) do
    @endpoint
    |> Request.new()
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.perform()
    |> Request.results(as: GetNetworkResponse)
  end
end
