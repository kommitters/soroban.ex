defmodule Soroban.Types.Address do
  @moduledoc """
  `Address` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.{SCAddress, SCVal}

  defstruct [:value, :type]

  @type value :: binary()
  @type type :: atom()
  @type errors :: atom()
  @type validation :: {:ok, value() | type()} | {:error, errors()}
  @type t :: %__MODULE__{value: value(), type: type()}

  @allowed_types ~w(account contract)a

  @impl true
  def new([{type, value}]) when is_binary(value) do
    case validate_type(type) do
      {:ok, type} -> %__MODULE__{value: value, type: type}
      error -> error
    end
  end

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value, type: type}) do
    case SCAddress.new([{type, value}]) do
      %SCAddress{} = sc_address -> SCVal.new(address: sc_address)
      error -> error
    end
  end

  def to_sc_val(_error), do: {:error, :invalid_struct_address}

  @spec validate_type(type :: type()) :: validation()
  defp validate_type(type) when type in @allowed_types, do: {:ok, type}
  defp validate_type(_type), do: {:error, :not_address_type}
end
