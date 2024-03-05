defmodule Soroban.RPC.Endpoint.Spec do
  @moduledoc """
  Specifies the callbacks to build the Soroban's endpoints.
  """

  alias Soroban.RPC.{Error, EventsPayload, HTTPError, Server}

  @type response :: {:ok, struct()} | {:error, Error.t() | HTTPError.t()}
  @type params :: String.t() | EventsPayload.t() | nil

  @callback request(server :: Server.t(), params :: params()) :: response()
end
