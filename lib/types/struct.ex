defmodule Soroban.Types.Struct do
  @moduledoc """
  `Struct` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Soroban.Types.StructField
  alias Stellar.TxBuild.SCVal
  defstruct [:values]

  @type errors :: atom()
  @type values :: list(StructField.t())
  @type validation :: {:ok, values()} | {:error, errors()}
  @type t :: %__MODULE__{values: values}

  @impl true
  def new(values) when is_list(values) do
    with {:ok, values} <- validate_struct_field_values(values) do
      %__MODULE__{values: values}
    end
  end

  def new(_values), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{values: values}) do
    values
    |> Enum.map(&StructField.to_map_entry/1)
    |> (&SCVal.new(map: &1)).()
  end

  def to_sc_val(_error), do: {:error, :invalid_struct}

  @spec validate_struct_field_values(values :: values()) :: validation()
  def validate_struct_field_values(values) do
    if Enum.all?(values, &is_struct(&1, StructField)),
      do: {:ok, values},
      else: {:error, :invalid_values}
  end
end
