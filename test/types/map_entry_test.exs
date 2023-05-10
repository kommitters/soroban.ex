defmodule Soroban.Types.MapEntryTest do
  use ExUnit.Case

  alias Soroban.Types.{MapEntry, Symbol, UInt32}
  alias Stellar.TxBuild.{SCMapEntry, SCVal}

  setup do
    key = Symbol.new("key")
    value = UInt32.new(100)
    entry = MapEntry.new({key, value})

    %{
      key: key,
      value: value,
      entry: entry
    }
  end

  describe "new/1" do
    test "with a valid value", %{key: key, value: value} do
      %MapEntry{key: ^key, value: ^value} = MapEntry.new({key, value})
    end

    test "with a nil value" do
      {:error, :invalid} = MapEntry.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = MapEntry.new(:atom)
    end
  end

  describe "to_map_entry/1" do
    test "with a valid vec type struct", %{entry: entry} do
      %SCMapEntry{
        key: %SCVal{type: :symbol, value: "key"},
        val: %SCVal{type: :u32, value: 100}
      } = MapEntry.to_map_entry(entry)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_map_entry} = MapEntry.to_map_entry(nil)
    end
  end
end
