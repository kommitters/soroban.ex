defmodule Soroban.RPC.GetHealth do
  @moduledoc """
  GetHealth request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.{GetHealthResponse, Request}

  @endpoint "getHealth"

  @impl true
  def request(params \\ nil)

  def request(nil) do
    @endpoint
    |> Request.new()
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.perform()
    |> Request.results(as: GetHealthResponse)
  end
end
