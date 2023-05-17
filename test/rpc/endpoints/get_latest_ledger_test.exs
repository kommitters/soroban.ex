defmodule Soroban.RPC.CannedGetLatestLedgerClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       id: "2a00000000000000000000000000000000000000000000000000000000000000",
       protocol_version: 20,
       sequence: 666
     }}
  end
end

defmodule Soroban.RPC.GetLatestLedgerTest do
  use ExUnit.Case

  alias Soroban.RPC.{
    CannedGetLatestLedgerClientImpl,
    GetLatestLedger,
    GetLatestLedgerResponse
  }

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedGetLatestLedgerClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)
  end

  test "request/0" do
    {:ok,
     %GetLatestLedgerResponse{
       id: "2a00000000000000000000000000000000000000000000000000000000000000",
       protocol_version: 20,
       sequence: 666
     }} = GetLatestLedger.request()
  end
end
