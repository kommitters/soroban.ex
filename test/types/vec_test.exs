defmodule Soroban.Types.VecTest do
  use ExUnit.Case

  alias Soroban.Types.{Int32, Symbol, Vec}
  alias Stellar.TxBuild.SCVal

  setup do
    value = [Int32.new(1)]
    values = [Symbol.new("A"), Symbol.new("B")]
    valid_vec = Vec.new(values)

    %{
      valid_vec: valid_vec,
      values: values,
      invalid_values: values ++ value
    }
  end

  describe "new/1" do
    test "with a valid value", %{values: values} do
      %Vec{values: ^values} = Vec.new(values)
    end

    test "with an invalid value", %{invalid_values: invalid_values} do
      {:error, :invalid_args} = Vec.new(invalid_values)
    end

    test "with a nil value" do
      {:error, :invalid} = Vec.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Vec.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid vec type struct", %{valid_vec: valid_vec} do
      %SCVal{
        type: :vec,
        value: [
          %SCVal{type: :symbol, value: "A"},
          %SCVal{type: :symbol, value: "B"}
        ]
      } = Vec.to_sc_val(valid_vec)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_vec} = Vec.to_sc_val(nil)
    end
  end
end
