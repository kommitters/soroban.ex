defmodule Soroban.Types.TimePoint do
  @moduledoc """
  `TimePoint` struct definition.
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
    case validate_time_point_range(value) do
      {:ok, time_point} -> %__MODULE__{value: time_point}
      error -> error
    end
  end

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}), do: SCVal.new(time_point: value)
  def to_sc_val(_error), do: {:error, :invalid_struct_time_point}

  @spec validate_time_point_range(value :: value()) :: validation()
  defp validate_time_point_range(value) when value in @int_range, do: {:ok, value}
  defp validate_time_point_range(_value), do: {:error, :not_in_time_point_range}
end
