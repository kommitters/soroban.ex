defmodule Soroban.Types.StructField do
  @moduledoc """
  `StructField` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Soroban.Types.Symbol
  alias Stellar.TxBuild.{SCMapEntry, SCVal}

  defstruct [:key, :value]

  @type key :: String.t()
  @type sc_val :: SCVal.t()
  @type t :: %__MODULE__{key: key(), value: struct()}

  @impl true
  def new({key, value}) when is_binary(key) and is_struct(value),
    do: %__MODULE__{key: key, value: value}

  def new(_args), do: {:error, :invalid}

  @impl true
  def to_map_entry(%__MODULE__{key: key, value: value}) do
    value = param_to_sc_val(value)

    key
    |> Symbol.new()
    |> Symbol.to_sc_val()
    |> SCMapEntry.new(value)
  end

  def to_map_entry(_error), do: {:error, :invalid_struct_field}

  @spec param_to_sc_val(param :: struct()) :: sc_val()
  defp param_to_sc_val(param) do
    struct = param.__struct__
    struct.to_sc_val(param)
  end
end
