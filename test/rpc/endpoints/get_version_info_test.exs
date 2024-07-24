defmodule Soroban.RPC.CannedGetVersionInfoClientImpl do
  @moduledoc false
  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       version: "21.1.0",
       commit_hash: "fcd2f0523f04279bae4502f3e3fa00ca627e6f6a",
       build_time_stamp: "2024-05-10T11:18:38",
       captive_core_version: "stellar-core 21.0.0.rc2 (c6f474133738ae5f6d11b07963ca841909210273)",
       protocol_version: 21
     }}
  end
end

defmodule Soroban.RPC.GetVersionInfoTest do
  use ExUnit.Case

  alias Soroban.RPC.{
    CannedGetVersionInfoClientImpl,
    GetVersionInfo,
    GetVersionInfoResponse,
    Server
  }

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedGetVersionInfoClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{server: Server.testnet()}
  end

  test "request/1", %{server: server} do
    {:ok,
     %GetVersionInfoResponse{
       version: "21.1.0",
       commit_hash: "fcd2f0523f04279bae4502f3e3fa00ca627e6f6a",
       build_time_stamp: "2024-05-10T11:18:38",
       captive_core_version: "stellar-core 21.0.0.rc2 (c6f474133738ae5f6d11b07963ca841909210273)",
       protocol_version: 21
     }} = GetVersionInfo.request(server)
  end
end
