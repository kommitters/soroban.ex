defmodule Soroban.Types.Spec do
  @moduledoc """
  Defines base types constructions.
  """
  alias Stellar.TxBuild.{SCMapEntry, SCVal}

  @type error :: {:error, atom()}
  @type sc_val :: SCVal.t()
  @type map_entry :: SCMapEntry.t()

  @callback new(any()) :: struct() | error()
  @callback to_sc_val(struct()) :: sc_val()
  @callback to_sc_map_entry(struct()) :: map_entry()

  @optional_callbacks to_sc_val: 1, to_sc_map_entry: 1
end
