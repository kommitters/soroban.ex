defmodule Soroban.RPC.Client do
  @moduledoc """
  Specifies the RPC for processing HTTP requests in the Soroban endpoint.
  """
  alias Soroban.RPC.Client

  @behaviour Client.Spec

  @impl true
  def request(method, url, headers \\ [], params \\ nil, opts \\ []),
    do: impl().request(method, url, headers, params, opts)

  @spec impl() :: atom()
  defp impl do
    Application.get_env(:soroban, :http_client_impl, Client.Default)
  end
end
