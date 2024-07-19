defmodule Soroban.RPC.Endpoint.Spec do
  @moduledoc """
  Specifies the callbacks to build the Soroban's endpoints.
  """

  alias Soroban.RPC.{Error, EventsPayload, HTTPError, Server, TransactionsPayload}

  @type response :: {:ok, struct()} | {:error, Error.t() | HTTPError.t()}
  @type params :: String.t() | EventsPayload.t() | keyword() | nil | TransactionsPayload.t()

  @callback request(server :: Server.t(), params :: params()) :: response()
end
