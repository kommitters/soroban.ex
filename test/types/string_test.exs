defmodule Soroban.Types.StringTest do
  use ExUnit.Case

  alias Soroban.Types.String
  alias Stellar.TxBuild.SCVal

  setup do
    string = String.new("string")
    %{string: string}
  end

  describe "new/1" do
    test "with a valid value" do
      %String{value: "string"} = String.new("string")
    end

    test "with an invalid value" do
      {:error, :invalid} = String.new(true)
    end

    test "with a nil value" do
      {:error, :invalid} = String.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = String.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{string: string} do
      %SCVal{type: :string, value: "string"} = String.to_sc_val(string)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_string} = String.to_sc_val(nil)
    end
  end
end
