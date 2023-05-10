defmodule Soroban.Types.EnumTest do
  use ExUnit.Case

  alias Soroban.Types.{Enum, UInt32}
  alias Stellar.TxBuild.SCVal

  setup do
    key = "key"
    value = UInt32.new(100)
    enum = Enum.new({key, value})
    enum2 = Enum.new(key)

    %{
      key: key,
      value: value,
      enum: enum,
      enum2: enum2
    }
  end

  describe "new/1" do
    test "with only key", %{key: key} do
      %Enum{key: ^key, value: nil} = Enum.new(key)
    end

    test "with key and value", %{key: key, value: value} do
      %Enum{key: ^key, value: ^value} = Enum.new({key, value})
    end

    test "with a nil value" do
      {:error, :invalid} = Enum.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Enum.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid enum type without value struct", %{enum2: enum2} do
      %SCVal{
        type: :vec,
        value: [
          %SCVal{type: :symbol, value: "key"}
        ]
      } = Enum.to_sc_val(enum2)
    end

    test "with a valid enum type struct", %{enum: enum} do
      %SCVal{
        type: :vec,
        value: [
          %SCVal{type: :symbol, value: "key"},
          %SCVal{type: :u32, value: 100}
        ]
      } = Enum.to_sc_val(enum)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_enum} = Enum.to_sc_val(nil)
    end
  end
end
