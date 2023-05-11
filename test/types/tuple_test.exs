defmodule Soroban.Types.TupleTest do
  use ExUnit.Case

  alias Soroban.Types.{Int32, Symbol, Tuple}
  alias Stellar.TxBuild.SCVal

  setup do
    values = [Symbol.new("A"), Symbol.new("B"), Int32.new(1)]
    tuple = Tuple.new(values)

    %{
      tuple: tuple,
      values: values
    }
  end

  describe "new/1" do
    test "with a valid value", %{values: values} do
      %Tuple{values: ^values} = Tuple.new(values)
    end

    test "with a nil value" do
      {:error, :invalid} = Tuple.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Tuple.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid vec type struct", %{tuple: tuple} do
      %SCVal{
        type: :vec,
        value: [
          %SCVal{type: :symbol, value: "A"},
          %SCVal{type: :symbol, value: "B"},
          %SCVal{type: :i32, value: 1}
        ]
      } = Tuple.to_sc_val(tuple)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_tuple} = Tuple.to_sc_val(nil)
    end
  end
end
