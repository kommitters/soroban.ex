defmodule Soroban.RPC.SimulateTransactionResponse do
  @moduledoc """
  `SimulateTransactionResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type min_resource_fee :: non_neg_integer()
  @type cost :: map()
  @type results :: list(map())
  @type transaction_data :: String.t()
  @type events :: list(String.t())
  @type restore_preamble :: map() | nil
  @type latest_ledger :: non_neg_integer()
  @type error :: String.t() | nil

  @type t :: %__MODULE__{
          min_resource_fee: min_resource_fee(),
          cost: cost(),
          results: results(),
          transaction_data: transaction_data(),
          events: events(),
          restore_preamble: restore_preamble(),
          latest_ledger: latest_ledger(),
          error: error()
        }

  defstruct [
    :min_resource_fee,
    :cost,
    :results,
    :transaction_data,
    :events,
    :restore_preamble,
    :latest_ledger,
    :error
  ]

  @impl true
  def new(attrs) do
    # If :min_resource_fee is present, convert it to an integer
    new_attrs =
      if Map.has_key?(attrs, :min_resource_fee) do
        Map.put(attrs, :min_resource_fee, String.to_integer(attrs.min_resource_fee))
      else
        attrs
      end

    struct(%__MODULE__{}, new_attrs)
  end
end
