defmodule Soroban.RPC.EventsPayload do
  @moduledoc """
  `EventsPayload` struct definition.
  """
  import Soroban.RPC.Helper
  alias Soroban.RPC.EventFilter

  @type args :: Keyword.t()
  @type error :: {:error, atom()}
  @type start_ledger :: non_neg_integer() | nil
  @type filters :: list(EventFilter.t()) | nil
  @type filters_validation :: {:ok, filters()} | error()
  @type pagination :: map() | nil
  @type request_args :: map() | :error
  @type t :: %__MODULE__{
          start_ledger: start_ledger(),
          filters: filters(),
          pagination: pagination()
        }

  defstruct [:start_ledger, :filters, :pagination]

  @spec new(args :: args()) :: t()
  def new(args) when is_list(args) do
    start_ledger = Keyword.get(args, :start_ledger)
    filters = Keyword.get(args, :filters)
    cursor = Keyword.get(args, :cursor)
    limit = Keyword.get(args, :limit)

    with {:ok, start_ledger} <- validate_start_ledger(start_ledger),
         {:ok, cursor} <- validate_cursor(cursor),
         {:ok, limit} <- validate_limit(limit),
         {:ok, filters} <- validate_filters(filters) do
      %__MODULE__{
        start_ledger: start_ledger,
        filters: filters,
        pagination: %{cursor: cursor, limit: limit}
      }
    end
  end

  def new(_args), do: {:error, :invalid_args}

  @spec to_request_args(t()) :: request_args()
  def to_request_args(%__MODULE__{
        start_ledger: start_ledger,
        filters: nil,
        pagination: pagination
      }) do
    %{startLedger: start_ledger, filters: nil, pagination: pagination}
  end

  def to_request_args(%__MODULE__{
        start_ledger: start_ledger,
        filters: filters,
        pagination: pagination
      }) do
    filters = Enum.map(filters, &EventFilter.to_request_args/1)
    %{startLedger: start_ledger, filters: filters, pagination: pagination}
  end

  def to_request_args(_struct), do: :error

  @spec validate_filters(filters :: filters()) :: filters_validation()
  defp validate_filters([%EventFilter{} = filter | _] = filters) when length(filters) in 1..5 do
    if Enum.any?(filters, fn f -> f.__struct__ != filter.__struct__ end),
      do: {:error, :invalid_filters},
      else: {:ok, filters}
  end

  defp validate_filters(nil), do: {:ok, nil}
  defp validate_filters(_filters), do: {:error, :invalid_filters}
end
