defmodule Soroban.Types.Int128Test do
  use ExUnit.Case

  alias Soroban.Types.Int128
  alias Stellar.TxBuild.SCVal

  setup do
    value = 24_324_234_234_234_234_343
    i128 = Int128.new(value)

    %{
      value: value,
      i128: i128
    }
  end

  describe "new/1" do
    test "with a valid value", %{value: value} do
      %Int128{value: ^value} = Int128.new(value)
    end

    test "with an invalid value" do
      {:error, :not_in_i128_range} =
        Int128.new(170_141_183_460_469_231_731_687_303_715_884_105_728)
    end

    test "with a nil value" do
      {:error, :invalid} = Int128.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Int128.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{i128: i128} do
      %SCVal{type: :i128, value: %{lo: 5_877_490_160_524_682_727, hi: 1}} = Int128.to_sc_val(i128)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_int128} = Int128.to_sc_val(nil)
    end
  end
end
