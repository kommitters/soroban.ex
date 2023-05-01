defmodule Soroban.Types.Bool do
  @moduledoc """
  `Bool` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:value]

  @type value :: boolean()
  @type t :: %__MODULE__{value: value()}

  @impl true
  def new(value) when is_boolean(value) do
    %__MODULE__{value: value}
  end

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}), do: SCVal.new(bool: value)
  def to_sc_val(_error), do: {:error, :invalid_struct_bool}
end
