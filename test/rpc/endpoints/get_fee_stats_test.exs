defmodule Soroban.RPC.CannedGetFeeStatsClientImpl do
  @moduledoc false
  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _header, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       soroban_inclusion_fee: %{
         max: "100",
         min: "100",
         mode: "100",
         p10: "100",
         p20: "100",
         p30: "100",
         p40: "100",
         p50: "100",
         p60: "100",
         p70: "100",
         p80: "100",
         p90: "100",
         p95: "100",
         p99: "100",
         transaction_count: "7",
         ledger_count: 50
       },
       inclusion_fee: %{
         max: "200",
         min: "100",
         mode: "200",
         p10: "100",
         p20: "100",
         p30: "100",
         p40: "150",
         p50: "200",
         p60: "200",
         p70: "200",
         p80: "200",
         p90: "200",
         p95: "200",
         p99: "200",
         transaction_count: "27",
         ledger_count: 10
       },
       latest_ledger: 619_731
     }}
  end
end

defmodule Soroban.RPC.GetFeeStatsTest do
  use ExUnit.Case

  alias Soroban.RPC.{
    CannedGetFeeStatsClientImpl,
    GetFeeStats,
    GetFeeStatsResponse,
    Server
  }

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedGetFeeStatsClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{server: Server.testnet()}
  end

  test "request/1", %{server: server} do
    {:ok,
     %GetFeeStatsResponse{
       soroban_inclusion_fee: %{
         max: "100",
         min: "100",
         mode: "100",
         p10: "100",
         p20: "100",
         p30: "100",
         p40: "100",
         p50: "100",
         p60: "100",
         p70: "100",
         p80: "100",
         p90: "100",
         p95: "100",
         p99: "100",
         transaction_count: "7",
         ledger_count: 50
       },
       inclusion_fee: %{
         max: "200",
         min: "100",
         mode: "200",
         p10: "100",
         p20: "100",
         p30: "100",
         p40: "150",
         p50: "200",
         p60: "200",
         p70: "200",
         p80: "200",
         p90: "200",
         p95: "200",
         p99: "200",
         transaction_count: "27",
         ledger_count: 10
       },
       latest_ledger: 619_731
     }} = GetFeeStats.request(server)
  end
end
