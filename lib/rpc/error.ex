defmodule Soroban.RPC.Error do
  @moduledoc """
  Represents an error which occurred during a Soroban RPC call.
  """

  @type code :: -32_099..-32_000 | -32_603..-32_600 | -32_700
  @type message :: String.t()
  @type t :: %__MODULE__{
          code: code(),
          message: message()
        }

  defstruct [:code, :message]

  @spec new(error :: map()) :: t()
  def new(%{code: code, message: message}),
    do: %__MODULE__{code: code, message: message}
end
