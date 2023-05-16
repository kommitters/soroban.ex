defmodule Soroban.RPC.CannedGetLedgerEntryClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       xdr: "AAAABhv6ziOnWcVRdGMZjtFKSWnLSndMp9JPVLLXxQqAvKqJAAAABQAAAAdDT1VOVEVSAAAAAAEAAAAD",
       last_modified_ledger_seq: "164986",
       latest_ledger: "179436"
     }}
  end
end

defmodule Soroban.RPC.GetLedgerEntryTest do
  use ExUnit.Case

  alias Soroban.RPC.{
    CannedGetLedgerEntryClientImpl,
    GetLedgerEntry,
    GetLedgerEntryResponse
  }

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedGetLedgerEntryClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{key: "AAAABhv6ziOnWcVRdGMZjtFKSWnLSndMp9JPVLLXxQqAvKqJAAAABQAAAAdDT1VOVEVSAA"}
  end

  test "request/1", %{key: key} do
    {:ok,
     %GetLedgerEntryResponse{
       xdr: "AAAABhv6ziOnWcVRdGMZjtFKSWnLSndMp9JPVLLXxQqAvKqJAAAABQAAAAdDT1VOVEVSAAAAAAEAAAAD",
       last_modified_ledger_seq: "164986",
       latest_ledger: "179436"
     }} = GetLedgerEntry.request(key)
  end
end
