defmodule Soroban.RPC.HTTPErrorTest do
  use ExUnit.Case

  alias Soroban.RPC.HTTPError

  describe "new/1" do
    test "with a Soroban HTTP error" do
      %HTTPError{status: 404, message: "not_found"} =
        HTTPError.new(%{status: 404, message: "not_found"})
    end

    test "with a network error" do
      %HTTPError{status: :network_error, message: :invalid} =
        HTTPError.new(%{status: :network_error, message: :invalid})
    end
  end
end
