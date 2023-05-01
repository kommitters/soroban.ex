defmodule Soroban.Types.Int64Test do
  use ExUnit.Case

  alias Soroban.Types.Int64
  alias Stellar.TxBuild.SCVal

  setup do
    i64 = Int64.new(1000)
    %{i64: i64}
  end

  describe "new/1" do
    test "with a valid value" do
      %Int64{value: 100_000} = Int64.new(100_000)
    end

    test "with an invalid value" do
      {:error, :not_in_i64_range} = Int64.new(9_223_372_036_854_775_808)
    end

    test "with a nil value" do
      {:error, :invalid} = Int64.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Int64.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{i64: i64} do
      %SCVal{type: :i64, value: 1000} = Int64.to_sc_val(i64)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_int64} = Int64.to_sc_val(nil)
    end
  end
end
