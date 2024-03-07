defmodule Soroban.RPC.ServerTest do
  use ExUnit.Case

  alias Soroban.RPC.Server

  test "new/1" do
    %Server{url: "https://soroban-testnet.stellar.org"} =
      Server.new("https://soroban-testnet.stellar.org")
  end

  test "testnet/0" do
    %Server{url: "https://soroban-testnet.stellar.org"} = Server.testnet()
  end

  test "futurenet/0" do
    %Server{url: "https://rpc-futurenet.stellar.org"} = Server.futurenet()
  end

  test "local/0" do
    %Server{url: "http://localhost:8000"} = Server.local()
  end
end
