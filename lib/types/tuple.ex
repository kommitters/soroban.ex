defmodule Soroban.Types.Tuple do
  @moduledoc """
  `Tuple` struct definition.
  """

  @behaviour Soroban.Types.Spec

  alias Stellar.TxBuild.SCVal

  defstruct [:values]

  @type values :: list(struct())
  @type errors :: atom()
  @type t :: %__MODULE__{values: values()}

  @impl true
  def new(values) when is_list(values), do: %__MODULE__{values: values}

  def new(_values), do: {:error, :invalid}

  @impl true
  def to_sc_val(%__MODULE__{values: values}) do
    values
    |> Enum.map(fn %{__struct__: struct} = arg -> struct.to_sc_val(arg) end)
    |> (&SCVal.new(vec: &1)).()
  end

  def to_sc_val(_error), do: {:error, :invalid_struct_vec}
end
