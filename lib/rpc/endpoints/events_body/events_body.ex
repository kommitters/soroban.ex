defmodule Soroban.RPC.EventsBody do
  @moduledoc """
  `EventsBody` struct definition.
  """
  alias Soroban.RPC.{EventFilter, PaginationOptions}

  @type args :: Keyword.t()
  @type cursor :: binary() | nil
  @type limit :: number() | nil
  @type error :: {:error, atom()}
  @type start_ledger :: String.t()
  @type start_ledger_validation() :: {:ok, start_ledger()} | error()
  @type filters :: list(EventFilter.t()) | nil
  @type filters_validation :: {:ok, filters()} | error()
  @type pagination :: PaginationOptions.t() | nil
  @type pagination_validation :: {:ok, pagination()} | error()
  @type request_args :: map()
  @type t :: %__MODULE__{
          start_ledger: start_ledger(),
          filters: filters(),
          pagination: pagination()
        }

  defstruct [:start_ledger, :filters, :pagination]

  @spec new(args :: args()) :: t()
  def new(args) do
    start_ledger = Keyword.get(args, :start_ledger)
    filters = Keyword.get(args, :filters)
    cursor = Keyword.get(args, :cursor)
    limit = Keyword.get(args, :limit)

    with {:ok, start_ledger} <- validate_start_ledger(start_ledger),
         {:ok, pagination} <- validate_pagination(cursor, limit),
         {:ok, filters} <- validate_filters(filters) do
      %__MODULE__{
        start_ledger: start_ledger,
        filters: filters,
        pagination: pagination
      }
    end
  end

  @spec to_request_args(t()) :: request_args()
  def to_request_args(%__MODULE__{
        start_ledger: start_ledger,
        filters: filters,
        pagination: pagination
      }) do
    filters = Enum.map(filters, &EventFilter.to_request_args/1)
    pagination = PaginationOptions.to_request_args(pagination)
    %{startLedger: start_ledger, filters: filters, pagination: pagination}
  end

  @spec validate_start_ledger(start_ledger :: start_ledger()) :: start_ledger_validation()
  defp validate_start_ledger(start_ledger) when is_binary(start_ledger), do: {:ok, start_ledger}
  defp validate_start_ledger(_start_ledger), do: {:error, :invalid_start_ledger}

  @spec validate_pagination(cursor :: cursor(), limit :: limit()) :: pagination_validation()
  defp validate_pagination(cursor, limit),
    do: {:ok, PaginationOptions.new(cursor: cursor, limit: limit)}

  @spec validate_filters(filters :: filters()) :: filters_validation()
  defp validate_filters([%EventFilter{} = filter | _] = filters) do
    if Enum.any?(filters, fn f -> f.__struct__ != filter.__struct__ end),
      do: {:error, :invalid_filter},
      else: {:ok, filters}
  end

  defp validate_filters(nil), do: {:ok, nil}
  defp validate_filters(_filters), do: {:error, :invalid_filters}
end
