defmodule Soroban.RPC.Response.Spec do
  @moduledoc """
  Defines RPC response type constructions.
  """

  @callback new(map()) :: struct()
end
