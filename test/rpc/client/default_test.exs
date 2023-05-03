defmodule Soroban.RPC.CannedHTTPClient do
  @moduledoc false

  @spec request(
          method :: atom(),
          url :: String.t(),
          headers :: list(),
          body :: String.t(),
          opt :: list()
        ) :: {:ok, non_neg_integer(), list(), String.t()} | {:error, Keyword.t()}
  def request(method, url, headers \\ [], body \\ "", opt \\ [])
  def request(:post, "/not_existing_url", _headers, _body, _opt), do: {:ok, 404, [], ""}
  def request(:post, "/server_error_mock", _headers, _body, _opt), do: {:ok, 500, [], ""}
  def request(:post, "/url_not_authorized", _headers, _body, _opt), do: {:ok, 401, [], ""}
  def request(:post, _url, [], _body, _opt), do: {:ok, 415, [], ""}

  def request(:post, _url, _headers, _body, [:with_body, follow_redirect: true, recv_timeout: 1]),
    do: {:error, :timeout}

  def request(:post, _url, _headers, body, _opt) do
    json_body =
      if Regex.match?(~r/\"method\":\"InvalidMethod\"/, body) do
        "{\"error\":{\"code\":-32601,\"data\":\"InvalidMethod\",\"message\":\"method not found\"},\"id\":8675309,\"jsonrpc\":\"2.0\"}"
      else
        "{\"id\":8675309,\"jsonrpc\":\"2.0\",\"result\":{\"status\":\"healthy\"}}"
      end

    {:ok, 200, [], json_body}
  end
end

defmodule Soroban.RPC.DefaultClientTest do
  use ExUnit.Case

  alias Soroban.RPC.{CannedHTTPClient, Client, Error, HTTPError}

  setup do
    Application.put_env(:soroban, :http_client, CannedHTTPClient)

    on_exit(fn ->
      Application.delete_env(:soroban, :http_client)
    end)

    %{
      url: "https://rpc-futurenet.stellar.org:443/",
      headers: [{"Content-Type", "application/json"}],
      method: "getHealth"
    }
  end

  describe "request/5" do
    test "success", %{url: url, headers: headers, method: method} do
      {:ok,
       %{
         result: %{
           status: "healthy"
         }
       }} = Client.request(method, url, headers)
    end

    test "success with error", %{url: url, headers: headers} do
      {:error,
       %Error{
         code: -32_601,
         message: "method not found"
       }} = Client.request("InvalidMethod", url, headers)
    end

    test "with an invalid url", %{method: method} do
      {:error, %HTTPError{status: 404, message: "not found"}} =
        Client.request(method, "/not_existing_url", [])
    end

    test "without headers", %{url: url, method: method} do
      {:error, %HTTPError{status: 415, message: "client error"}} = Client.request(method, url, [])
    end

    test "with an unauthorized access", %{headers: headers, method: method} do
      {:error, %HTTPError{status: 401, message: "unauthorized"}} =
        Client.request(method, "/url_not_authorized", headers)
    end

    test "with a server error", %{headers: headers, method: method} do
      {:error, %HTTPError{status: 500, message: "server error"}} =
        Client.request(method, "/server_error_mock", headers)
    end

    test "timeout", %{url: url, headers: headers, method: method} do
      {:error, %HTTPError{status: :network_error, message: :timeout}} =
        Client.request(method, url, headers, %{}, recv_timeout: 1)
    end
  end
end
