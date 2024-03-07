defmodule Soroban.RPC.GetEvents do
  @moduledoc """
  GetEvents request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.EventsPayload
  alias Soroban.RPC.{GetEventsResponse, Request}

  @endpoint "getEvents"

  @impl true
  def request(server, %EventsPayload{} = payload) do
    payload = EventsPayload.to_request_args(payload)

    server
    |> Request.new(@endpoint)
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.add_params(payload)
    |> Request.perform()
    |> Request.results(as: GetEventsResponse)
  end
end
