defmodule Soroban.Types.AddressTest do
  use ExUnit.Case

  alias Soroban.Types.Address
  alias Stellar.TxBuild.{SCAddress, SCVal}

  setup do
    account_address = Address.new("GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A")

    contract_address = Address.new("CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN")
    %{account_address: account_address, contract_address: contract_address}
  end

  describe "new/1" do
    test "with a valid value" do
      %Address{value: "CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN"} =
        Address.new("CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN")
    end

    test "with an invalid value" do
      {:error, :invalid_address} = Address.new("CCEMOFO5TE7FGOAJOA3RDH")
    end

    test "with a nil value" do
      {:error, :invalid} = Address.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Address.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid account type struct", %{account_address: account_address} do
      %SCVal{
        type: :address,
        value: %SCAddress{
          type: :account,
          value: "GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A"
        }
      } = Address.to_sc_val(account_address)
    end

    test "with a valid contract type struct", %{contract_address: contract_address} do
      %SCVal{
        type: :address,
        value: %SCAddress{
          type: :contract,
          value: "CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN"
        }
      } = Address.to_sc_val(contract_address)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_address} = Address.to_sc_val(nil)
    end
  end
end
