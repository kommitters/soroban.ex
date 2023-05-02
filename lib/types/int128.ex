defmodule Soroban.Types.Int128 do
  @moduledoc """
  `Int128` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:value]

  @type value :: integer()
  @type errors :: atom()
  @type validation :: {:ok, value()} | {:error, errors()}
  @type t :: %__MODULE__{value: value()}

  @int_range -170_141_183_460_469_231_731_687_303_715_884_105_728..170_141_183_460_469_231_731_687_303_715_884_105_727

  @impl true
  def new(value) when is_integer(value) do
    case validate_int128_range(value) do
      {:ok, i128} -> %__MODULE__{value: i128}
      error -> error
    end
  end

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}) do
    <<hi::size(64), lo::size(64)>> = <<value::size(128)>>
    SCVal.new(i128: %{lo: lo, hi: hi})
  end

  def to_sc_val(_error), do: {:error, :invalid_struct_int128}

  @spec validate_int128_range(value :: value()) :: validation()
  defp validate_int128_range(value) when value in @int_range, do: {:ok, value}
  defp validate_int128_range(_value), do: {:error, :not_in_i128_range}
end
