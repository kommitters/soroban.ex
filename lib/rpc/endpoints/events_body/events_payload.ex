defmodule Soroban.RPC.EventsPayload do
  @moduledoc """
  `EventsPayload` struct definition.
  """
  alias Soroban.RPC.EventFilter

  @type args :: Keyword.t()
  @type cursor :: binary() | nil
  @type cursor_validation :: {:ok, cursor()}
  @type limit :: number() | nil
  @type limit_validation :: {:ok, limit()}
  @type error :: {:error, atom()}
  @type start_ledger :: String.t() | nil
  @type start_ledger_validation :: {:ok, start_ledger()} | error()
  @type filters :: list(EventFilter.t()) | nil
  @type filters_validation :: {:ok, filters()} | error()
  @type pagination :: map() | nil
  @type pagination_validation :: {:ok, pagination()} | error()
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
        filters: filters,
        pagination: pagination
      }) do
    filters = Enum.map(filters, &EventFilter.to_request_args/1)
    %{startLedger: start_ledger, filters: filters, pagination: pagination}
  end

  def to_request_args(_struct), do: :error

  @spec validate_start_ledger(start_ledger :: start_ledger()) :: start_ledger_validation()
  defp validate_start_ledger(start_ledger) when is_binary(start_ledger), do: {:ok, start_ledger}
  defp validate_start_ledger(nil), do: {:ok, nil}
  defp validate_start_ledger(_start_ledger), do: {:error, :invalid_start_ledger}

  @spec validate_cursor(cursor :: cursor()) :: cursor_validation()
  defp validate_cursor(cursor) when is_binary(cursor), do: {:ok, cursor}
  defp validate_cursor(nil), do: {:ok, nil}
  defp validate_cursor(_cursor), do: {:error, :invalid_cursor}

  @spec validate_limit(limit :: limit()) :: limit_validation()
  defp validate_limit(limit) when is_number(limit), do: {:ok, limit}
  defp validate_limit(nil), do: {:ok, nil}
  defp validate_limit(_limit), do: {:error, :invalid_limit}

  @spec validate_filters(filters :: filters()) :: filters_validation()
  defp validate_filters([%EventFilter{} = filter | _] = filters) when length(filters) in 1..5 do
    if Enum.any?(filters, fn f -> f.__struct__ != filter.__struct__ end),
      do: {:error, :invalid_filters},
      else: {:ok, filters}
  end

  defp validate_filters(nil), do: {:ok, nil}
  defp validate_filters(_filters), do: {:error, :invalid_filters}
end
