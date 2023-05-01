defmodule Soroban.Types.BoolTest do
  use ExUnit.Case

  alias Soroban.Types.Bool
  alias Stellar.TxBuild.SCVal

  setup do
    bool = Bool.new(true)
    %{bool: bool}
  end

  describe "new/1" do
    test "with a valid value" do
      %Bool{value: true} = Bool.new(true)
    end

    test "with an invalid value" do
      {:error, :invalid} = Bool.new("Invalid")
    end

    test "with a nil value" do
      {:error, :invalid} = Bool.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Bool.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{bool: bool} do
      %SCVal{type: :bool, value: true} = Bool.to_sc_val(bool)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_bool} = Bool.to_sc_val(nil)
    end
  end
end
