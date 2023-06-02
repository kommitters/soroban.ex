defmodule Soroban.RPC.SimulateTransactionCannedClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       transaction_data:
         "AAAAAwAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcAAAAG4avr0cYyEk0etiaStUgJ889XGSqUqZEZcCyR+ma87LIAAAAUAAAAB8zDhJ3ZTMHmdBjlVh/7d1HDdo+QI1ZXGmeRzBwVAoVXAAAAAQAAAAbhq+vRxjISTR62JpK1SAnzz1cZKpSpkRlwLJH6ZrzssgAAABUAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3ACb/vgAAFcQAAAC0AAABrAAAAAAAAABUAAAAAA==",
       events: nil,
       min_resource_fee: "79488",
       results: [
         %{
           auth: nil,
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
       transaction_data:
         "AAAAAwAAAAAAAAAAYvwdC9CRsrYcDdZWNGsqaNfTR8bywsjubQRHAlb8BfcAAAAG4avr0cYyEk0etiaStUgJ889XGSqUqZEZcCyR+ma87LIAAAAUAAAAB8zDhJ3ZTMHmdBjlVh/7d1HDdo+QI1ZXGmeRzBwVAoVXAAAAAQAAAAbhq+vRxjISTR62JpK1SAnzz1cZKpSpkRlwLJH6ZrzssgAAABUAAAAAAAAAAGL8HQvQkbK2HA3WVjRrKmjX00fG8sLI7m0ERwJW/AX3ACb/vgAAFcQAAAC0AAABrAAAAAAAAABUAAAAAA==",
       events: nil,
       min_resource_fee: "79488",
       results: [
         %{
           auth: nil,
           xdr: "AAAAEAAAAAEAAAACAAAADwAAAAVIZWxsbwAAAAAAAA8AAAAFd29ybGQAAAA="
         }
       ],
       cost: %{cpu_insns: "1048713", mem_bytes: "1201148"},
       latest_ledger: "475528",
       error: nil
     }} = SimulateTransaction.request(transaction_xdr)
  end
end
