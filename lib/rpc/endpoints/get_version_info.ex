defmodule Soroban.RPC.GetVersionInfo do
  @moduledoc """
  GetVersionInfo request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{GetVersionInfoResponse, Request}

  @endpoint "getVersionInfo"

  @impl true
  def request(server, _params \\ nil) do
    server
    |> Request.new(@endpoint)
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.perform()
    |> Request.results(as: GetVersionInfoResponse)
  end
end
