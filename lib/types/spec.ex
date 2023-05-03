defmodule Soroban.Types.Spec do
  @moduledoc """
  Defines base types constructions.
  """
  alias Stellar.TxBuild.SCVal

  @type error :: {:error, atom()}
  @type sc_val :: SCVal.t()

  @callback new(any()) :: struct() | error()
  @callback to_sc_val(struct()) :: sc_val()
end
