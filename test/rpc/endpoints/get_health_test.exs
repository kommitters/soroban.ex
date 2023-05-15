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

defmodule Soroban.RPC.Endpoints.GetHealthTest do
  use ExUnit.Case

  alias Soroban.RPC.{
    CannedGetHealthClientImpl,
    GetHealth,
    GetHealthResponse
  }

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedGetHealthClientImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)
  end

  test "request/0" do
    {:ok,
     %GetHealthResponse{
       status: "healthy"
     }} = GetHealth.request()
  end
end
