defmodule Soroban.Types.Option do
  @moduledoc """
  `Option` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:value]

  @type sc_val :: SCVal.t()
  @type value :: struct() | nil
  @type t :: %__MODULE__{value: value()}

  @impl true
  def new(value \\ nil)
  def new(nil), do: %__MODULE__{}
  def new(value) when is_struct(value), do: %__MODULE__{value: value}
  def new(_value), do: {:error, :invalid_option}

  @impl true
  def to_sc_val(%__MODULE__{value: nil}), do: SCVal.new(void: nil)
  def to_sc_val(%__MODULE__{value: value}), do: param_to_sc_val(value)
  def to_sc_val(_error), do: {:error, :invalid_struct_bool}

  @spec param_to_sc_val(param :: struct()) :: sc_val()
  defp param_to_sc_val(param) do
    struct = param.__struct__
    struct.to_sc_val(param)
  end
end
