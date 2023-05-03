defmodule Soroban.RPC.ErrorTest do
  use ExUnit.Case

  alias Soroban.RPC.Error

  describe "new/1" do
    test "with a Soroban RPC error" do
      %Error{code: -32_602, message: "invalid_xdr"} =
        Error.new(%{code: -32_602, message: "invalid_xdr"})
    end
  end
end
