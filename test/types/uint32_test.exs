defmodule Soroban.Types.UInt32Test do
  use ExUnit.Case

  alias Soroban.Types.UInt32
  alias Stellar.TxBuild.SCVal

  setup do
    u32 = UInt32.new(1000)
    %{u32: u32}
  end

  describe "new/1" do
    test "with a valid value" do
      %UInt32{value: 4_294_967_295} = UInt32.new(4_294_967_295)
    end

    test "with an invalid value" do
      {:error, :not_in_u32_range} = UInt32.new(-10)
    end

    test "with a nil value" do
      {:error, :invalid} = UInt32.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = UInt32.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{u32: u32} do
      %SCVal{type: :u32, value: 1000} = UInt32.to_sc_val(u32)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_uint32} = UInt32.to_sc_val(nil)
    end
  end
end
