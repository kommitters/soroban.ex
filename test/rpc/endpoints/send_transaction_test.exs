defmodule Soroban.RPC.SendTransactionCannedClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612"
     }}
  end
end

defmodule Soroban.RPC.SendTransactionTest do
  use ExUnit.Case

  alias Soroban.RPC.{
    SendTransaction,
    SendTransactionCannedClientImpl,
    SendTransactionResponse,
    Server
  }

  setup do
    Application.put_env(:soroban, :http_client_impl, SendTransactionCannedClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    transaction_xdr =
      "AAAAAgAAAADBPp7TMinJylnn+6dQXJACNc15LF+aJ2Py1BaR4P10JAAAAGQAAFBfAAAAIQAAAAEAAAAAAAAAAAAAAABkUtg3AAAAAAAAAAEAAAABAAAAAME+ntMyKcnKWef7p1BckAI1zXksX5onY/LUFpHg/XQkAAAAGAAAAAAAAAADAAAADQAAACAU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAAA8AAAAFaGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAAAAAAAAAAAAAAAAAB4P10JAAAAEDS4+hvSG1JqhOIPaGSqUerNsjhIcS+AwWhH/K8IOafcmMlZJoyZvMftV1QcdWA/LQhr2QJRTWNT6I52/eTP3IH"

    %{transaction_xdr: transaction_xdr, server: Server.testnet()}
  end

  test "request/1", %{transaction_xdr: transaction_xdr, server: server} do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
       latest_ledger: 45_075_181,
       latest_ledger_close_time: "1683150612",
       error_result_xdr: nil,
       diagnostic_events_xdr: nil
     }} = SendTransaction.request(server, transaction_xdr)
  end
end
