defmodule Soroban.RPC.Response.Spec do
  @moduledoc """
  Defines RPC response types constructions.
  """

  @type attrs :: map() | struct() | Keyword.t() | list() | String.t()
  @type error :: {:error, Keyword.t()}
  @type resource :: struct()

  @callback new(any()) :: struct() | error()
end
