defmodule Soroban.Types.Enum do
  @moduledoc """
  `Enum` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Soroban.Types.Symbol
  alias Stellar.TxBuild.SCVal

  defstruct [:key, :value]

  @type sc_val :: SCVal.t()
  @type t :: %__MODULE__{key: String.t(), value: struct()}

  @impl true
  def new(key) when is_binary(key),
    do: %__MODULE__{key: key}

  def new({key, value}) when is_binary(key) and is_struct(value),
    do: %__MODULE__{key: key, value: value}

  def new(_args), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{key: key, value: nil}) do
    key
    |> Symbol.new()
    |> Symbol.to_sc_val()
    |> (&SCVal.new(vec: [&1])).()
  end

  def to_sc_val(%__MODULE__{key: key, value: value}) do
    value = param_to_sc_val(value)

    key
    |> Symbol.new()
    |> Symbol.to_sc_val()
    |> (&SCVal.new(vec: [&1, value])).()
  end

  def to_sc_val(_error), do: {:error, :invalid_struct_enum}

  @spec param_to_sc_val(param :: struct()) :: sc_val()
  defp param_to_sc_val(param) do
    struct = param.__struct__
    struct.to_sc_val(param)
  end
end
