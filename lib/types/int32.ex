defmodule Soroban.Types.Int32 do
  @moduledoc """
  `Int32` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:value]

  @type value :: integer()
  @type errors :: atom()
  @type validation :: {:ok, value()} | {:error, errors()}
  @type t :: %__MODULE__{value: value()}

  @int_range -2_147_483_648..2_147_483_647

  @impl true
  def new(value) when is_integer(value) do
    case validate_int32_range(value) do
      {:ok, i32} -> %__MODULE__{value: i32}
      error -> error
    end
  end

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}), do: SCVal.new(i32: value)
  def to_sc_val(_error), do: {:error, :invalid_struct_int32}

  @spec validate_int32_range(value :: value()) :: validation()
  defp validate_int32_range(value) when value in @int_range, do: {:ok, value}
  defp validate_int32_range(_value), do: {:error, :not_in_i32_range}
end
