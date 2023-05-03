defmodule Soroban.RPC.Client.CannedRequestImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(
        _method,
        _url,
        _headers,
        _params,
        _opts
      ) do
    send(self(), {:soroban_response, 200})
    {:ok, 200, [], nil}
  end
end

defmodule Soroban.RPC.RequestTest do
  use ExUnit.Case

  alias Soroban.RPC.{Client.CannedRequestImpl, GetTransactionResponse, HTTPError, Request}
  alias Soroban.Test.Fixtures.RPC

  setup do
    Application.put_env(:soroban, :http_client_impl, CannedRequestImpl)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client_impl)
    end)

    url = "https://rpc-futurenet.stellar.org:443/"
    headers = [{"Content-Type", "application/json"}]
    method = "getTransaction"

    params = %{
      hash: "2a3c55cc19ed98e40f8eff426f1e16f2cff84bb0a75be45c2ed4b62159380e9a"
    }

    %{
      url: url,
      method: method,
      headers: headers,
      params: params
    }
  end

  test "new/1", %{url: url, method: method} do
    %Request{
      method: ^method,
      url: ^url,
      params: nil,
      headers: []
    } = Request.new(method)
  end

  test "add_params/2", %{method: method, params: params} do
    %Request{method: ^method, params: ^params} =
      method
      |> Request.new()
      |> Request.add_params(params)
  end

  test "add_headers/2", %{method: method, headers: headers} do
    %Request{method: ^method, headers: ^headers} =
      method
      |> Request.new()
      |> Request.add_headers(headers)
  end

  test "perform/2", %{
    method: method,
    params: params,
    headers: headers
  } do
    method
    |> Request.new()
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
