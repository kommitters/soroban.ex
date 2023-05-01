defmodule Soroban.Types.AddressTest do
  use ExUnit.Case

  alias Soroban.Types.Address
  alias Stellar.TxBuild.{SCAddress, SCVal}

  setup do
    address_account =
      Address.new(account: "GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A")

    address_contract = Address.new(contract: "GCIZ3GSM5XL7OUS4UP64THMDZ7CZ3ZWN")
    %{address_account: address_account, address_contract: address_contract}
  end

  describe "new/1" do
    test "with a valid value" do
      %Address{value: "GCIZ3GSM5XL7OUS4UP64THMDZ7CZ3ZWN", type: :contract} =
        Address.new(contract: "GCIZ3GSM5XL7OUS4UP64THMDZ7CZ3ZWN")
    end

    test "with an invalid value" do
      {:error, :invalid} = Address.new(contract: :invalid)
    end

    test "with an invalid type" do
      {:error, :not_address_type} = Address.new(invalid: "GCIZ3GSM5XL7OUS4UP64THMDZ7CZ3ZWN")
    end

    test "with a nil value" do
      {:error, :invalid} = Address.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Address.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid account type struct", %{address_account: address_account} do
      %SCVal{
        type: :address,
        value: %SCAddress{
          type: :account,
          value: "GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A"
        }
      } = Address.to_sc_val(address_account)
    end

    test "with a valid contract type struct", %{address_contract: address_contract} do
      %SCVal{
        type: :address,
        value: %SCAddress{type: :contract, value: "GCIZ3GSM5XL7OUS4UP64THMDZ7CZ3ZWN"}
      } = Address.to_sc_val(address_contract)
    end

    test "with a valid contract type struct but creates an invalid SCAddress" do
      {:error, :invalid_account_id} =
        [account: "GCIZ3GSM5XL7OUS4UP64THMDZ7CZ3ZWN"]
        |> Address.new()
        |> Address.to_sc_val()
    end

    test "with an invalid value" do
      {:error, :invalid_struct_address} = Address.to_sc_val(nil)
    end
  end
end
