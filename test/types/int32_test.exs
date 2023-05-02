defmodule Soroban.Types.Int32Test do
  use ExUnit.Case

  alias Soroban.Types.Int32
  alias Stellar.TxBuild.SCVal

  setup do
    i32 = Int32.new(1000)
    %{i32: i32}
  end

  describe "new/1" do
    test "with a valid value" do
      %Int32{value: 100_000} = Int32.new(100_000)
    end

    test "with an invalid value" do
      {:error, :not_in_i32_range} = Int32.new(2_147_483_648)
    end

    test "with a nil value" do
      {:error, :invalid} = Int32.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Int32.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{i32: i32} do
      %SCVal{type: :i32, value: 1000} = Int32.to_sc_val(i32)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_int32} = Int32.to_sc_val(nil)
    end
  end
end
