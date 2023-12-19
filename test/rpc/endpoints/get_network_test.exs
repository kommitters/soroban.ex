defmodule Soroban.RPC.CannedGetNetworkClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       friendbot_url: "https://friendbot-futurenet.stellar.org/",
       passphrase: "Test SDF Future Network ; October 2022",
       protocol_version: 20
     }}
  end
end

defmodule Soroban.RPC.GetNetworkTest do
  use ExUnit.Case

  alias Soroban.RPC.{
    CannedGetNetworkClientImpl,
    GetNetwork,
    GetNetworkResponse
  }

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedGetNetworkClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)
  end

  test "request/0" do
    {:ok,
     %GetNetworkResponse{
       friendbot_url: "https://friendbot-futurenet.stellar.org/",
       passphrase: "Test SDF Future Network ; October 2022",
       protocol_version: 20
     }} = GetNetwork.request()
  end
end
