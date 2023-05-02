defmodule Soroban.Types.UInt64Test do
  use ExUnit.Case

  alias Soroban.Types.UInt64
  alias Stellar.TxBuild.SCVal

  setup do
    u64 = UInt64.new(1000)
    %{u64: u64}
  end

  describe "new/1" do
    test "with a valid value" do
      %UInt64{value: 4_294_967_295} = UInt64.new(4_294_967_295)
    end

    test "with an invalid value" do
      {:error, :not_in_u64_range} = UInt64.new(-10)
    end

    test "with a nil value" do
      {:error, :invalid} = UInt64.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = UInt64.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{u64: u64} do
      %SCVal{type: :u64, value: 1000} = UInt64.to_sc_val(u64)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_uint64} = UInt64.to_sc_val(nil)
    end
  end
end
