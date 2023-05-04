defmodule Soroban.RPC.SimulateTransactionCannedClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       results: [
         %{
           auth: nil,
           events: nil,
           footprint:
             "AAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAA",
           xdr: "AAAAEAAAAAEAAAACAAAADwAAAAVIZWxsbwAAAAAAAA8AAAAFd29ybGQAAAA="
         }
       ],
       cost: %{cpu_insns: "1048713", mem_bytes: "1201148"},
       latest_ledger: "475528"
     }}
  end
end

defmodule Soroban.RPC.SimulateTransactionTest do
  use ExUnit.Case

  alias Soroban.RPC.{
    SimulateTransaction,
    SimulateTransactionCannedClientImpl,
    SimulateTransactionResponse
  }

  setup do
    Application.put_env(:soroban, :http_client_impl, SimulateTransactionCannedClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    transaction_xdr =
      "AAAAAgAAAADWKIRtrzg/aTCtUHeZnpyYu0iNxJxcn4tr0jXG2hOIlwAAAGQABzbWAAAAAwAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAGAAAAAAAAAAEAAAADQAAACC8xDySpTRgcsckFZY9QBvIP3LL70Jp0xG3cmpCvp0d/QAAAA8AAAAJaW5jcmVtZW50AAAAAAAAEwAAAAAAAAAA1iiEba84P2kwrVB3mZ6cmLtIjcScXJ+La9I1xtoTiJcAAAADAAAACgAAAAAAAAAAAAAAAQAAAAC8xDySpTRgcsckFZY9QBvIP3LL70Jp0xG3cmpCvp0d/QAAAAlpbmNyZW1lbnQAAAAAAAACAAAAEwAAAAAAAAAA1iiEba84P2kwrVB3mZ6cmLtIjcScXJ+La9I1xtoTiJcAAAADAAAACgAAAAAAAAAAAAAAAAAAAAA="

    %{transaction_xdr: transaction_xdr}
  end

  test "request/1", %{transaction_xdr: transaction_xdr} do
    {:ok,
     %SimulateTransactionResponse{
       results: [
         %{
           auth: nil,
           events: nil,
           footprint:
             "AAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAA",
           xdr: "AAAAEAAAAAEAAAACAAAADwAAAAVIZWxsbwAAAAAAAA8AAAAFd29ybGQAAAA="
         }
       ],
       cost: %{cpu_insns: "1048713", mem_bytes: "1201148"},
       latest_ledger: "475528",
       error: nil
     }} = SimulateTransaction.request(transaction_xdr)
  end
end
