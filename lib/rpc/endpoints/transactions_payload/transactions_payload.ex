defmodule Soroban.RPC.TransactionsPayload do
  @moduledoc """
  `TransactionsPayload` struct definition.
  """
  import Soroban.RPC.Helper

  @type args :: Keyword.t()
  @type start_ledger :: non_neg_integer() | nil
  @type pagination :: map() | nil
  @type request_args :: map() | :error
  @type t :: %__MODULE__{
          start_ledger: start_ledger(),
          pagination: pagination()
        }

  defstruct [:start_ledger, :pagination]

  @spec new(args :: args()) :: t()
  def new(args) when is_list(args) do
    start_ledger = Keyword.get(args, :start_ledger)
    cursor = Keyword.get(args, :cursor)
    limit = Keyword.get(args, :limit)

    with {:ok, start_ledger} <- validate_start_ledger(start_ledger),
         {:ok, cursor} <- validate_cursor(cursor),
         {:ok, limit} <- validate_limit(limit) do
      %__MODULE__{
        start_ledger: start_ledger,
        pagination: %{cursor: cursor, limit: limit}
      }
    end
  end

  def new(_args), do: {:error, :invalid_args}

  @spec to_request_args(t()) :: request_args()
  def to_request_args(%__MODULE__{
        start_ledger: start_ledger,
        pagination: pagination
      }) do
    %{startLedger: start_ledger, filters: nil, pagination: pagination}
  end

  def to_request_args(_struct), do: :error
end
