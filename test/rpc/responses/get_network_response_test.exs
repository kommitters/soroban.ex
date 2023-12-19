defmodule Soroban.RPC.GetNetworkResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.GetNetworkResponse

  setup do
    %{
      result: %{
        friendbot_url: "https://friendbot-futurenet.stellar.org/",
        passphrase: "Test SDF Future Network ; October 2022",
        protocol_version: 20
      }
    }
  end

  describe "new/1" do
    test "when successful transaction", %{
      result:
        %{
          friendbot_url: friendbot_url,
          passphrase: passphrase,
          protocol_version: protocol_version
        } = result
    } do
      %GetNetworkResponse{
        friendbot_url: ^friendbot_url,
        passphrase: ^passphrase,
        protocol_version: ^protocol_version
      } = GetNetworkResponse.new(result)
    end
  end
end
