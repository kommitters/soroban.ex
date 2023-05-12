defmodule Soroban.RPC.PaginationOptions do
  @derive Jason.Encoder
  defstruct [:cursor, :limit]

  def new(cursor: cursor, limit: limit) do
    with {:ok, cursor} <- validate_cursor(cursor),
         {:ok, limit} <- validate_limit(limit) do
      %__MODULE__{
        cursor: cursor,
        limit: limit
      }
    end
  end

  defp validate_cursor(cursor) when is_binary(cursor), do: {:ok, cursor}
  defp validate_cursor(nil), do: {:ok, nil}
  defp validate_cursor(_cursor), do: {:error, :invalid_cursor}

  defp validate_limit(limit) when is_number(limit), do: {:ok, limit}
  defp validate_limit(nil), do: {:ok, nil}
  defp validate_limit(_limit), do: {:error, :invalid_limit}
end
