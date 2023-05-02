defmodule Soroban.Types.BytesTest do
  use ExUnit.Case

  alias Soroban.Types.Bytes
  alias Stellar.TxBuild.SCVal

  setup do
    bytes = Bytes.new("bytes")
    %{bytes: bytes}
  end

  describe "new/1" do
    test "with a valid value" do
      %Bytes{value: "bytes"} = Bytes.new("bytes")
    end

    test "with an invalid value" do
      {:error, :invalid} = Bytes.new(true)
    end

    test "with a nil value" do
      {:error, :invalid} = Bytes.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Bytes.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{bytes: bytes} do
      %SCVal{type: :bytes, value: "bytes"} = Bytes.to_sc_val(bytes)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_bytes} = Bytes.to_sc_val(nil)
    end
  end
end
