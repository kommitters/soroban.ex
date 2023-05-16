defmodule Soroban.RPC.Endpoint.Spec do
  @moduledoc """
  Specifies the callbacks to build the Soroban's endpoints.
  """

  alias Soroban.RPC.{Error, EventsPayload, HTTPError}

  @type response :: {:ok, struct()} | {:error, Error.t() | HTTPError.t()}
  @type params :: String.t() | EventsPayload.t() | nil

  @callback request(params :: params()) :: response()
end
