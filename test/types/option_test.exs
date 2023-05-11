defmodule Soroban.Types.OptionTest do
  use ExUnit.Case

  alias Soroban.Types.{Option, UInt32}
  alias Stellar.TxBuild.SCVal

  setup do
    value = UInt32.new(100)
    empty_option = Option.new()
    option = Option.new(value)
    %{value: value, empty_option: empty_option, option: option}
  end

  describe "new/1" do
    test "with the default value" do
      %Option{value: nil} = Option.new()
    end

    test "with a valid value", %{value: value} do
      %Option{value: ^value} = Option.new(value)
    end

    test "with an invalid value" do
      {:error, :invalid_option} = Option.new("invalid")
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{option: option} do
      %SCVal{type: :u32, value: 100} = Option.to_sc_val(option)
    end

    test "with a valid empty struct", %{empty_option: empty_option} do
      %SCVal{type: :void, value: nil} = Option.to_sc_val(empty_option)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_bool} = Option.to_sc_val(nil)
    end
  end
end
