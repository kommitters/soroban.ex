defmodule Soroban.RPC.CannedGetHealthClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(_endpoint, _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       status: "healthy"
     }}
  end
end

defmodule Soroban.RPC.GetHealthTest do
  use ExUnit.Case

  alias Soroban.RPC.{
    CannedGetHealthClientImpl,
    GetHealth,
    GetHealthResponse,
    Server
  }

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedGetHealthClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    %{server: Server.testnet()}
  end

  test "request/1", %{server: server} do
    {:ok,
     %GetHealthResponse{
       status: "healthy"
     }} = GetHealth.request(server)
  end
end
