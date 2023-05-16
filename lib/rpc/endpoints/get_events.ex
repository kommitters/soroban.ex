defmodule Soroban.RPC.GetEvents do
  @moduledoc """
  GetEvents request implementation for Soroban RPC.
  """
  @behaviour Soroban.RPC.Endpoint.Spec

  alias Soroban.RPC.EventsBody
  alias Soroban.RPC.{GetEventsResponse, Request}

  @endpoint "getEvents"

  @impl true
  def request(%EventsBody{} = body) do
    body = EventsBody.to_request_args(body)

    @endpoint
    |> Request.new()
    |> Request.add_headers([{"Content-Type", "application/json"}])
    |> Request.add_params(body)
    |> Request.perform()
    |> Request.results(as: GetEventsResponse)
  end
end
