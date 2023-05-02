defmodule Soroban.Types.SymbolTest do
  use ExUnit.Case

  alias Soroban.Types.Symbol
  alias Stellar.TxBuild.SCVal

  setup do
    symbol = Symbol.new("symbol")
    %{symbol: symbol}
  end

  describe "new/1" do
    test "with a valid value" do
      %Symbol{value: "symbol"} = Symbol.new("symbol")
    end

    test "with an invalid value" do
      {:error, :invalid} = Symbol.new(true)
    end

    test "with a nil value" do
      {:error, :invalid} = Symbol.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Symbol.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{symbol: symbol} do
      %SCVal{type: :symbol, value: "symbol"} = Symbol.to_sc_val(symbol)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_symbol} = Symbol.to_sc_val(nil)
    end
  end
end
