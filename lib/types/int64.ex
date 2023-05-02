defmodule Soroban.Types.Int64 do
  @moduledoc """
  `Int64` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:value]

  @type value :: integer()
  @type errors :: atom()
  @type validation :: {:ok, value()} | {:error, errors()}
  @type t :: %__MODULE__{value: value()}

  @int_range -9_223_372_036_854_775_808..9_223_372_036_854_775_807

  @impl true
  def new(value) when is_integer(value) do
    case validate_int64_range(value) do
      {:ok, i64} -> %__MODULE__{value: i64}
      error -> error
    end
  end

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}), do: SCVal.new(i64: value)
  def to_sc_val(_error), do: {:error, :invalid_struct_int64}

  @spec validate_int64_range(value :: value()) :: validation()
  defp validate_int64_range(value) when value in @int_range, do: {:ok, value}
  defp validate_int64_range(_value), do: {:error, :not_in_i64_range}
end
