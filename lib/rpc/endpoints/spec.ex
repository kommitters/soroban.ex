defmodule Soroban.RPC.Endpoint.Spec do
  @moduledoc """
  Specifies the callbacks to build the Soroban's endpoints.
  """

  alias Soroban.RPC.EventsBody
  alias Soroban.RPC.{Error, HTTPError}

  @type response :: {:ok, struct()} | {:error, Error.t() | HTTPError.t()}
  @type params :: String.t() | Keyword.t() | EventsBody.t() | nil

  @callback request(params :: params()) :: response()
end
