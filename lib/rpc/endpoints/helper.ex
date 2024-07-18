defmodule Soroban.RPC.Helper do
  @moduledoc """
  Helper functions for RPC endpoints.
  """

  @type error :: {:error, atom()}
  @type start_ledger :: non_neg_integer() | nil
  @type start_ledger_validation :: {:ok, start_ledger()} | error()
  @type cursor :: binary() | nil
  @type cursor_validation :: {:ok, cursor()}
  @type limit :: number() | nil
  @type limit_validation :: {:ok, limit()}

  @spec validate_start_ledger(start_ledger :: start_ledger()) :: start_ledger_validation()
  def validate_start_ledger(start_ledger) when is_number(start_ledger) and start_ledger >= 0,
    do: {:ok, start_ledger}

  def validate_start_ledger(nil), do: {:ok, nil}
  def validate_start_ledger(_start_ledger), do: {:error, :invalid_start_ledger}

  @spec validate_cursor(cursor :: cursor()) :: cursor_validation()
  def validate_cursor(cursor) when is_binary(cursor), do: {:ok, cursor}
  def validate_cursor(nil), do: {:ok, nil}
  def validate_cursor(_cursor), do: {:error, :invalid_cursor}

  @spec validate_limit(limit :: limit()) :: limit_validation()
  def validate_limit(limit) when is_number(limit), do: {:ok, limit}
  def validate_limit(nil), do: {:ok, nil}
  def validate_limit(_limit), do: {:error, :invalid_limit}
end
