defmodule Soroban.Types.Int256Test do
  use ExUnit.Case

  alias Soroban.Types.Int256
  alias Stellar.TxBuild.SCVal

  setup do
    value = 340_282_366_920_938_463_463_374_607_431_768_211_455
    int256 = Int256.new(value)
    %{int256: int256, value: value}
  end

  describe "new/1" do
    test "with a valid value" do
      %Int256{value: 4_294_967_295} = Int256.new(4_294_967_295)
    end

    test "with a nil value" do
      {:error, :invalid} = Int256.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Int256.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{value: value, int256: int256} do
      value_bin = <<value::size(256)>>

      %SCVal{type: :i256, value: ^value_bin} = Int256.to_sc_val(int256)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_int256} = Int256.to_sc_val(nil)
    end
  end
end
