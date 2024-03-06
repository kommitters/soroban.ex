defmodule Soroban.RPC.Client.CannedRequestImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(
        _endpoint,
        _url,
        _headers,
        _params,
        _opts
      ) do
    send(self(), {:soroban_response, 200})
    {:ok, %{result: "result"}}
  end
end

defmodule Soroban.RPC.RequestTest do
  use ExUnit.Case

  alias Soroban.RPC.{Client.CannedRequestImpl, GetTransactionResponse, HTTPError, Request, Server}
  alias Soroban.Test.Fixtures.RPC

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedRequestImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    server = Server.testnet()
    headers = [{"Content-Type", "application/json"}]
    endpoint = "getTransaction"

    params = %{
      hash: "2a3c55cc19ed98e40f8eff426f1e16f2cff84bb0a75be45c2ed4b62159380e9a"
    }

    %{
      server: server,
      endpoint: endpoint,
      headers: headers,
      params: params
    }
  end

  test "new/1", %{server: %Server{url: url} = server, endpoint: endpoint} do
    %Request{
      endpoint: ^endpoint,
      url: ^url,
      params: nil,
      headers: []
    } = Request.new(server, endpoint)
  end

  test "add_params/2", %{server: server,endpoint: endpoint, params: params} do
    %Request{endpoint: ^endpoint, params: ^params} =
      server
      |> Request.new(endpoint)
      |> Request.add_params(params)
  end

  test "add_headers/2", %{server: server, endpoint: endpoint, headers: headers} do
    %Request{endpoint: ^endpoint, headers: ^headers} =
      server
      |> Request.new(endpoint)
      |> Request.add_headers(headers)
  end

  test "perform/2", %{
    server: server,
    endpoint: endpoint,
    params: params,
    headers: headers
  } do
    server
    |> Request.new(endpoint)
    |> Request.add_params(params)
    |> Request.add_headers(headers)
    |> Request.perform()

    assert_receive({:soroban_response, 200})
  end

  test "results/2 success" do
    get_transaction_response = RPC.fixture("getTransaction")

    {:ok, %GetTransactionResponse{}} =
      Request.results({:ok, get_transaction_response}, as: GetTransactionResponse)
  end

  test "results/2 error" do
    error = %HTTPError{status: 404, message: "not found"}
    {:error, ^error} = Request.results({:error, error}, as: GetTransactionResponse)
  end
end
