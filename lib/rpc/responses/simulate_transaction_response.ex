defmodule Soroban.RPC.SimulateTransactionResponse do
  @moduledoc """
  `SimulateTransactionResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type results :: list(map())
  @type cost :: map()
  @type latest_ledger :: String.t()
  @type error :: String.t() | nil
  @type t :: %__MODULE__{
          results: results(),
          cost: cost(),
          latest_ledger: latest_ledger(),
          error: error()
        }

  defstruct [
    :transaction_data,
    :events,
    :min_resource_fee,
    :results,
    :cost,
    :latest_ledger,
    :error
  ]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
