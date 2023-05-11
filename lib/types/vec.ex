defmodule Soroban.Types.Vec do
  @moduledoc """
  `Vec` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:values]

  @type values :: list(struct())
  @type errors :: atom()
  @type validation :: {:ok, values()} | {:error, errors()}
  @type t :: %__MODULE__{values: values()}

  @impl true
  def new(values) when is_list(values) do
    with {:ok, values} <- validate_vec_values(values) do
      %__MODULE__{values: values}
    end
  end

  def new(_values), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{values: values}) do
    values
    |> Enum.map(fn %{__struct__: struct} = arg -> struct.to_sc_val(arg) end)
    |> (&SCVal.new(vec: &1)).()
  end

  def to_sc_val(_error), do: {:error, :invalid_struct_vec}

  @spec validate_vec_values(values :: values()) :: validation()
  defp validate_vec_values([value | _] = values) do
    if Enum.any?(values, fn val -> val.__struct__ != value.__struct__ end),
      do: {:error, :invalid_args},
      else: {:ok, values}
  end
end
