defmodule Soroban.Types.String do
  @moduledoc """
  `String` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:value]

  @type value :: binary()
  @type t :: %__MODULE__{value: value()}

  @impl true
  def new(value) when is_binary(value) do
    %__MODULE__{value: value}
  end

  def new(_value), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{value: value}), do: SCVal.new(string: value)
  def to_sc_val(_error), do: {:error, :invalid_struct_string}
end
