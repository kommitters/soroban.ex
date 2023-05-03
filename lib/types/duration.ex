defmodule Soroban.Types.Duration do
  @moduledoc """
  `Duration` struct definition.
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
    case validate_duration_range(value) do
      {:ok, duration} -> %__MODULE__{value: duration}
      error -> error
    end
  end

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}), do: SCVal.new(duration: value)
  def to_sc_val(_error), do: {:error, :invalid_struct_duration}

  @spec validate_duration_range(value :: value()) :: validation()
  defp validate_duration_range(value) when value in @int_range, do: {:ok, value}
  defp validate_duration_range(_value), do: {:error, :not_in_duration_range}
end
