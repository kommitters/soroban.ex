defmodule Soroban.Types.UInt32 do
  @moduledoc """
  `UInt32` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:value]

  @type value :: non_neg_integer()
  @type errors :: atom()
  @type validation :: {:ok, value()} | {:error, errors()}
  @type t :: %__MODULE__{value: value()}

  @int_range 0..4_294_967_295

  @impl true
  def new(value) when is_integer(value) do
    case validate_uint32_range(value) do
      {:ok, u32} -> %__MODULE__{value: u32}
      error -> error
    end
  end

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}), do: SCVal.new(u32: value)
  def to_sc_val(_error), do: {:error, :invalid_struct_uint32}

  @spec validate_uint32_range(value :: value()) :: validation()
  defp validate_uint32_range(value) when value in @int_range, do: {:ok, value}
  defp validate_uint32_range(_value), do: {:error, :not_in_u32_range}
end
