defmodule Soroban.Types.StructFieldTest do
  use ExUnit.Case

  alias Soroban.Types.{StructField, UInt32}
  alias Stellar.TxBuild.{SCMapEntry, SCVal}

  setup do
    key = "foo"
    value = UInt32.new(100)
    struct = StructField.new({key, value})

    %{
      key: key,
      value: value,
      struct: struct
    }
  end

  describe "new/1" do
    test "with a valid value", %{key: key, value: value} do
      %StructField{key: ^key, value: ^value} = StructField.new({key, value})
    end

    test "with a nil value" do
      {:error, :invalid} = StructField.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = StructField.new(:atom)
    end
  end

  describe "to_sc_map_entry/1" do
    test "with a valid vec type struct", %{struct: struct} do
      %SCMapEntry{
        key: %SCVal{type: :symbol, value: "foo"},
        val: %SCVal{type: :u32, value: 100}
      } = StructField.to_sc_map_entry(struct)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_field} = StructField.to_sc_map_entry(nil)
    end
  end
end
