defmodule Soroban.Types.Spec do
  @moduledoc """
  Defines base types constructions.
  """

  @type reasons :: Keyword.t()
  @type error :: {:error, reasons()}

  @callback new(any()) :: struct() | error()
  @callback to_sc_val(struct()) :: struct()
end
