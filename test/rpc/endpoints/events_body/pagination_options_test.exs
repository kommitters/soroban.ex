defmodule Soroban.RPC.PaginationOptionsTest do
  use ExUnit.Case

  alias Soroban.RPC.PaginationOptions

  setup do
    cursor = "1234-1"
    limit = 2
    pagination_options = PaginationOptions.new(cursor: nil, limit: limit)

    %{cursor: cursor, limit: limit, pagination_options: pagination_options}
  end

  describe "new/1" do
    test "with a valid values", %{cursor: cursor, limit: limit} do
      %PaginationOptions{cursor: ^cursor, limit: ^limit} =
        PaginationOptions.new(cursor: cursor, limit: limit)
    end

    test "with a nil values" do
      %PaginationOptions{cursor: nil, limit: nil} = PaginationOptions.new(cursor: nil, limit: nil)
    end

    test "with an invalid cursor", %{limit: limit} do
      {:error, :invalid_cursor} = PaginationOptions.new(cursor: 10, limit: limit)
    end

    test "with an invalid limit", %{cursor: cursor} do
      {:error, :invalid_limit} = PaginationOptions.new(cursor: cursor, limit: "invalid")
    end
  end

  describe "to_request_args/1" do
    test "with a valid struct", %{pagination_options: pagination_options} do
      %{cursor: nil, limit: 2} = PaginationOptions.to_request_args(pagination_options)
    end

    test "with an invalid value" do
      :error = PaginationOptions.to_request_args(nil)
    end
  end
end
