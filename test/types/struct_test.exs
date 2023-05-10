defmodule Soroban.Types.StructTest do
  use ExUnit.Case

  alias Soroban.Types.{Struct, StructField, UInt32}
  alias Stellar.TxBuild.{SCMapEntry, SCVal}

  setup do
    key = "key"
    value = UInt32.new(100)
    field = StructField.new({key, value})
    struct = Struct.new([field])

    %{
      field: field,
      struct: struct
    }
  end

  describe "new/1" do
    test "with a valid value", %{field: field} do
      %Struct{values: [^field]} = Struct.new([field])
    end

    test "with a nil value" do
      {:error, :invalid} = Struct.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Struct.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct type struct", %{struct: struct} do
      %SCVal{
        type: :map,
        value: [
          %SCMapEntry{
            key: %SCVal{type: :symbol, value: "key"},
            val: %SCVal{type: :u32, value: 100}
          }
        ]
      } = Struct.to_sc_val(struct)
    end

    test "with an invalid value" do
      {:error, :invalid_struct} = Struct.to_sc_val(nil)
    end
  end
end
