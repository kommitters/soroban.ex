defmodule Soroban.RPC.HTTPError do
  @moduledoc """
  Represents an error which occurred during a Soroban RPC call.
  """

  @type status :: 400..599 | :network_error
  @type message :: String.t() | atom()
  @type t :: %__MODULE__{
          status: status(),
          message: message()
        }

  defstruct [:status, :message]

  @spec new(error :: map()) :: t()
  def new(%{status: status, message: message}),
    do: %__MODULE__{status: status, message: message}
end
