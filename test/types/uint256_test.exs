defmodule Soroban.Types.UInt256Test do
  use ExUnit.Case

  alias Soroban.Types.UInt256
  alias Stellar.TxBuild.SCVal

  setup do
    value = 340_282_366_920_938_463_463_374_607_431_768_211_455
    u256 = UInt256.new(value)
    %{value: value, u256: u256}
  end

  describe "new/1" do
    test "with a valid value", %{value: value} do
      %UInt256{value: ^value} = UInt256.new(value)
    end

    test "with a nil value" do
      {:error, :invalid} = UInt256.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = UInt256.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{value: value, u256: u256} do
      value_bin = <<value::size(256)>>

      %SCVal{type: :u256, value: ^value_bin} = UInt256.to_sc_val(u256)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_uint256} = UInt256.to_sc_val(nil)
    end
  end
end
