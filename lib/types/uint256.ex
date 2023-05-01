defmodule Soroban.Types.UInt256 do
  @moduledoc """
  `UInt256` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:value]

  @type value :: non_neg_integer()
  @type t :: %__MODULE__{value: value()}

  @impl true
  def new(value) when is_integer(value), do: %__MODULE__{value: value}
  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}), do: SCVal.new(u256: <<value::size(256)>>)
  def to_sc_val(_error), do: {:error, :invalid_struct_uint256}
end
