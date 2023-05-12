defmodule Soroban.RPC.EventsBody do
  alias Soroban.RPC.PaginationOptions
  alias Soroban.RPC.EventFilter

  @type key :: atom()
  @type string_value :: String.t()
  @type value :: any()
  @type words :: list(string_value())
  @type start_ledger :: String.t()
  @type filters :: list(EventFilter.t())
  @type pagination :: struct()
  @type t :: %__MODULE__{
          start_ledger: start_ledger(),
          filters: filters(),
          pagination: pagination
        }

  defstruct [:start_ledger, :filters, :pagination]

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

  def format(body) when is_struct(body) do
    body
    |> Map.from_struct()
    |> Enum.map(fn {k, v} -> {format_key(k), format(v)} end)
    |> Enum.into(%{})
  end

  def format(value), do: value

  @spec format_key(key :: atom()) :: String.t()
  defp format_key(key) when is_atom(key) do
    key = Atom.to_string(key)

    if String.contains?(key, "_") do
      [first_word | rest] = String.split(key, "_")
      first_word <> camelize(rest)
    else
      key
    end
  end

  @spec camelize(words :: words()) :: string_value()
  defp camelize([]), do: ""
  defp camelize([word | rest]), do: Macro.camelize(word) <> camelize(rest)

  defp validate_start_ledger(start_ledger) when is_binary(start_ledger), do: {:ok, start_ledger}
  defp validate_start_ledger(_start_ledger), do: {:error, :invalid_start_ledger}

  defp validate_pagination(cursor, limit) do
    case PaginationOptions.new(cursor: cursor, limit: limit) do
      %PaginationOptions{} = pagination -> {:ok, pagination}
      error -> error
    end
  end

  #TODO list of EventF
  defp validate_filters(%EventFilter{} = filters), do: {:ok, filters}
  defp validate_filters(nil), do: {:ok, nil}
  defp validate_filters(_filters), do: {:error, :invalid_filters}
end
