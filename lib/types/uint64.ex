defmodule Soroban.Types.UInt64 do
  @moduledoc """
  `UInt64` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:value]

  @type value :: non_neg_integer()
  @type errors :: atom()
  @type validation :: {:ok, value()} | {:error, errors()}
  @type t :: %__MODULE__{value: value()}

  @int_range 0..18_446_744_073_709_551_615

  @impl true
  def new(value) when is_integer(value) do
    case validate_uint64_range(value) do
      {:ok, u64} -> %__MODULE__{value: u64}
      error -> error
    end
  end

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}), do: SCVal.new(u64: value)
  def to_sc_val(_error), do: {:error, :invalid_struct_uint64}

  @spec validate_uint64_range(value :: value()) :: validation()
  defp validate_uint64_range(value) when value in @int_range, do: {:ok, value}
  defp validate_uint64_range(_value), do: {:error, :not_in_u64_range}
end
