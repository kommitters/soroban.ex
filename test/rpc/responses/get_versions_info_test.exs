defmodule Soroban.RPC.GetVetsionInfoResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.GetVersionInfoResponse

  setup do
    %{
      result: %{
        version: "21.1.0",
        commit_hash: "fcd2f0523f04279bae4502f3e3fa00ca627e6f6a",
        build_time_stamp: "2024-05-10T11:18:38",
        captive_core_version:
          "stellar-core 21.0.0.rc2 (c6f474133738ae5f6d11b07963ca841909210273)",
        protocol_version: 21
      }
    }
  end

  describe "new/1" do
    test "when successful transaction", %{
      result:
        %{
          version: version,
          commit_hash: commit_hash,
          build_time_stamp: build_time_stamp,
          captive_core_version: captive_core_version,
          protocol_version: protocol_version
        } = result
    } do
      %GetVersionInfoResponse{
        version: ^version,
        commit_hash: ^commit_hash,
        build_time_stamp: ^build_time_stamp,
        captive_core_version: ^captive_core_version,
        protocol_version: ^protocol_version
      } = GetVersionInfoResponse.new(result)
    end
  end
end
