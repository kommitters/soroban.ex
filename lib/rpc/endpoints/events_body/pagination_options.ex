defmodule Soroban.RPC.PaginationOptions do
  @moduledoc """
  `PaginationOptions` struct definition.
  """

  @type cursor :: binary() | nil
  @type cursor_validation :: {:ok, cursor()}
  @type limit :: number() | nil
  @type limit_validation :: {:ok, limit()}
  @type request_args :: map() | :error
  @type t :: %__MODULE__{
          cursor: cursor(),
          limit: limit()
        }

  defstruct [:cursor, :limit]

  @spec new(Keyword.t()) :: t()
  def new(cursor: cursor, limit: limit) do
    with {:ok, cursor} <- validate_cursor(cursor),
         {:ok, limit} <- validate_limit(limit) do
      %__MODULE__{
        cursor: cursor,
        limit: limit
      }
    end
  end

  @spec to_request_args(t()) :: request_args()
  def to_request_args(%__MODULE__{cursor: cursor, limit: limit}),
    do: %{cursor: cursor, limit: limit}

  def to_request_args(_struct), do: :error

  @spec validate_cursor(cursor :: cursor()) :: cursor_validation()
  defp validate_cursor(cursor) when is_binary(cursor), do: {:ok, cursor}
  defp validate_cursor(nil), do: {:ok, nil}
  defp validate_cursor(_cursor), do: {:error, :invalid_cursor}

  @spec validate_limit(limit :: limit()) :: limit_validation()
  defp validate_limit(limit) when is_number(limit), do: {:ok, limit}
  defp validate_limit(nil), do: {:ok, nil}
  defp validate_limit(_limit), do: {:error, :invalid_limit}
end
