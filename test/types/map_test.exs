defmodule Soroban.Types.MapTest do
  use ExUnit.Case

  alias Soroban.Types.{Map, MapEntry, Symbol, UInt32}
  alias Stellar.TxBuild.{SCMapEntry, SCVal}

  setup do
    key = Symbol.new("key")
    value = UInt32.new(100)
    entry = MapEntry.new({key, value})
    map = Map.new([entry, entry])

    %{
      entry: entry,
      map: map
    }
  end

  describe "new/1" do
    test "with a valid value", %{entry: entry} do
      %Map{values: [^entry]} = Map.new([entry])
    end

    test "with a nil value" do
      {:error, :invalid} = Map.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Map.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid vec type struct", %{map: map} do
      %SCVal{
        type: :map,
        value: [
          %SCMapEntry{
            key: %SCVal{type: :symbol, value: "key"},
            val: %SCVal{type: :u32, value: 100}
          },
          %SCMapEntry{
            key: %SCVal{type: :symbol, value: "key"},
            val: %SCVal{type: :u32, value: 100}
          }
        ]
      } = Map.to_sc_val(map)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_map} = Map.to_sc_val(nil)
    end
  end
end
