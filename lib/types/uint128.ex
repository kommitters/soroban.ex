defmodule Soroban.Types.UInt128 do
  @moduledoc """
  `UInt128` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:value]

  @type value :: non_neg_integer()
  @type errors :: atom()
  @type validation :: {:ok, value()} | {:error, errors()}
  @type t :: %__MODULE__{value: value()}

  @int_range 0..340_282_366_920_938_463_463_374_607_431_768_211_455

  @impl true
  def new(value) when is_integer(value) do
    case validate_uint128_range(value) do
      {:ok, u128} -> %__MODULE__{value: u128}
      error -> error
    end
  end

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}) do
    <<hi::size(64), lo::size(64)>> = <<value::size(128)>>
    SCVal.new(u128: %{lo: lo, hi: hi})
  end

  def to_sc_val(_error), do: {:error, :invalid_struct_uint128}

  @spec validate_uint128_range(value :: value()) :: validation()
  defp validate_uint128_range(value) when value in @int_range, do: {:ok, value}
  defp validate_uint128_range(_value), do: {:error, :not_in_u128_range}
end
