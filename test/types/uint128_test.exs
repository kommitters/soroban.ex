defmodule Soroban.Types.UInt128Test do
  use ExUnit.Case

  alias Soroban.Types.UInt128
  alias Stellar.TxBuild.SCVal

  setup do
    value = 340_282_366_920_938_463_463_374_607_431_768_211_455
    u128 = UInt128.new(value)
    %{value: value, u128: u128}
  end

  describe "new/1" do
    test "with a valid value", %{value: value} do
      %UInt128{value: ^value} = UInt128.new(value)
    end

    test "with an invalid value" do
      {:error, :not_in_u128_range} = UInt128.new(-10)
    end

    test "with a nil value" do
      {:error, :invalid} = UInt128.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = UInt128.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{u128: u128} do
      %SCVal{
        type: :u128,
        value: %{hi: 18_446_744_073_709_551_615, lo: 18_446_744_073_709_551_615}
      } = UInt128.to_sc_val(u128)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_uint128} = UInt128.to_sc_val(nil)
    end
  end
end
