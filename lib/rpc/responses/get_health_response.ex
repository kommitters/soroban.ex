defmodule Soroban.RPC.GetHealthResponse do
  @moduledoc """
  `GetHealthResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type status :: String.t()
  @type t :: %__MODULE__{
          status: status()
        }

  defstruct [:status]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
