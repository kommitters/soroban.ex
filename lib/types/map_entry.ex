defmodule Soroban.Types.MapEntry do
  @moduledoc """
  `MapEntry` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.{SCMapEntry, SCVal}

  defstruct [:key, :value]

  @type sc_val :: SCVal.t()
  @type t :: %__MODULE__{key: struct(), value: struct()}

  @impl true
  def new({key, value}) when is_struct(key) and is_struct(value),
    do: %__MODULE__{key: key, value: value}

  def new(_args), do: {:error, :invalid}

  @impl true
  def to_map_entry(%__MODULE__{key: key, value: value}) do
    key = param_to_sc_val(key)
    value = param_to_sc_val(value)

    SCMapEntry.new(key, value)
  end

  def to_map_entry(_error), do: {:error, :invalid_struct_map_entry}

  @spec param_to_sc_val(param :: struct()) :: sc_val()
  defp param_to_sc_val(param) do
    struct = param.__struct__
    struct.to_sc_val(param)
  end
end
