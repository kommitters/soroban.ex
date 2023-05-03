defmodule Soroban.RPC.CannedClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_method, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})
    :ok
  end
end

defmodule Soroban.RPC.ClientTest do
  use ExUnit.Case

  alias Soroban.RPC.{CannedClientImpl, Client}

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)
  end

  test "request/6" do
    Client.request(
      "getHealth",
      "https://rpc-futurenet.stellar.org:443/"
    )

    assert_receive({:request, "RESPONSE"})
  end
end
