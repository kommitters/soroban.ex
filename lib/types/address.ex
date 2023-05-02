defmodule Soroban.Types.Address do
  @moduledoc """
  `Address` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.{SCAddress, SCVal}

  defstruct [:value]

  @type value :: binary()
  @type type :: atom()
  @type errors :: atom()
  @type validation :: {:ok, value()} | {:error, errors()}
  @type t :: %__MODULE__{value: value()}

  @impl true
  def new(value) when is_binary(value) do
    with {:ok, value} <- validate_address(value) do
      %__MODULE__{value: value}
    end
  end

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}) do
    value
    |> SCAddress.new()
    |> (&SCVal.new(address: &1)).()
  end

  def to_sc_val(_error), do: {:error, :invalid_struct_address}

  @spec validate_address(value :: value()) :: validation()
  defp validate_address(value) do
    case SCAddress.new(value) do
      %SCAddress{} -> {:ok, value}
      _error -> {:error, :invalid_address}
    end
  end
end
