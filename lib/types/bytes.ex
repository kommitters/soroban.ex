defmodule Soroban.Types.Bytes do
  @moduledoc """
  `Bytes` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:value]

  @type value :: binary()
  @type t :: %__MODULE__{value: value()}

  @impl true
  def new(value) when is_binary(value), do: %__MODULE__{value: value}

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}), do: SCVal.new(bytes: value)
  def to_sc_val(_error), do: {:error, :invalid_struct_bytes}
end
