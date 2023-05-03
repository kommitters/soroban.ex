defmodule Soroban.RPC.Endpoint.Spec do
  @moduledoc """
  Defines RPC response type constructions.
  """
  @type response :: tuple()
  @type transaction :: String.t()

  @callback request(transaction :: transaction()) :: response()
end
