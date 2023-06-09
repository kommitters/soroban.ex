defmodule Soroban.Types.Map do
  @moduledoc """
  `Map` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Soroban.Types.MapEntry
  alias Stellar.TxBuild.SCVal

  defstruct [:values]

  @type errors :: atom()
  @type values :: list(MapEntry.t())
  @type validation :: {:ok, values()} | {:error, errors()}
  @type t :: %__MODULE__{values: values}

  @impl true
  def new(values \\ [])

  def new(values) when is_list(values) do
    with {:ok, values} <- validate_map_entry_values(values) do
      %__MODULE__{values: values}
    end
  end

  def new(_values), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{values: values}) do
    values
    |> Enum.map(&MapEntry.to_sc_map_entry/1)
    |> (&SCVal.new(map: &1)).()
  end

  def to_sc_val(_error), do: {:error, :invalid_struct_map}

  @spec validate_map_entry_values(values :: values()) :: validation()
  defp validate_map_entry_values(values) do
    if Enum.all?(values, &is_struct(&1, MapEntry)),
      do: {:ok, values},
      else: {:error, :invalid_values}
  end
end
