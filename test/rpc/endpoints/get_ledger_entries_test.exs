defmodule Soroban.RPC.CannedGetLedgerEntriesClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       entries: [
         %{
           key: "AAAAB+qfy4GuVKKfazvyk4R9P9fpo2n9HICsr+xqvVcTF+DC",
           xdr: "AAAABwAAAADqn8uBrlSin2s78pOEfT/X6aNp/RyArK/sar1XExfgwgAAAAphIGNvbnRyYWN0AAA=",
           last_modified_ledger_seq: 2_552_504,
           live_until_ledger_seq: 2_552_504
         }
       ],
       latest_ledger: 45_075_181
     }}
  end
end

defmodule Soroban.RPC.GetLedgerEntriesTest do
  use ExUnit.Case

  alias Soroban.RPC.{
    CannedGetLedgerEntriesClientImpl,
    GetLedgerEntries,
    GetLedgerEntriesResponse
  }

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedGetLedgerEntriesClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{keys: ["AAAAB+qfy4GuVKKfazvyk4R9P9fpo2n9HICsr+xqvVcTF+DC"]}
  end

  test "request/1", %{keys: keys} do
    {:ok,
     %GetLedgerEntriesResponse{
       entries: [
         %{
           key: "AAAAB+qfy4GuVKKfazvyk4R9P9fpo2n9HICsr+xqvVcTF+DC",
           xdr: "AAAABwAAAADqn8uBrlSin2s78pOEfT/X6aNp/RyArK/sar1XExfgwgAAAAphIGNvbnRyYWN0AAA=",
           last_modified_ledger_seq: 2_552_504,
           live_until_ledger_seq: 2_552_504
         }
       ],
       latest_ledger: 45_075_181
     }} = GetLedgerEntries.request(keys)
  end
end
