defmodule Soroban.RPC.Client.Default do
  @moduledoc """
  Hackney HTTP client implementation.
  This implementation allows you to use your own JSON encoding library. The default is Jason.
  """

  alias Soroban.RPC.{Error, HTTPError}

  @behaviour Soroban.RPC.Client.Spec

  @type error_message :: String.t()
  @type status :: pos_integer()
  @type headers :: [{binary(), binary()}, ...]
  @type body :: binary()
  @type success_response :: {:ok, status(), headers(), body()}
  @type error_response :: {:error, status(), headers(), body()} | {:error, any()}
  @type client_response :: success_response() | error_response()
  @type parsed_response :: {:ok, map()} | {:error, Error.t()} | {:error, HTTPError.t()}

  @errors %{
    400 => "bad request",
    401 => "unauthorized",
    404 => "not found"
  }

  @impl true
  def request(endpoint, url, headers \\ [], params \\ nil, opts \\ []) do
    options = http_options(opts)

    body =
      endpoint
      |> request_body(params)
      |> json_library().encode!()

    :post
    |> http_client().request(url, headers, body, options)
    |> handle_response()
  end

  @spec handle_response(response :: client_response()) :: parsed_response()

  defp handle_response({:ok, status, _headers, body}) when status in 200..299 do
    decoded_body = json_library().decode!(body, keys: &snake_case_atom/1)

    case decoded_body do
      %{error: error} -> {:error, Error.new(error)}
      _decoded_body -> {:ok, decoded_body}
    end
  end

  defp handle_response({:ok, status, _headers, ""}) when status in 400..499 do
    error = Map.get(@errors, status, "client error")
    {:error, HTTPError.new(%{status: status, message: error})}
  end

  defp handle_response({:ok, status, _headers, ""}) when status in 500..599 do
    error = Map.get(@errors, status, "server error")
    {:error, HTTPError.new(%{status: status, message: error})}
  end

  defp handle_response({:error, reason}),
    do: {:error, HTTPError.new(%{status: :network_error, message: reason})}

  @spec snake_case_atom(string :: String.t()) :: atom()
  defp snake_case_atom(string) do
    string
    |> Macro.underscore()
    |> String.to_atom()
  end

  @spec http_client() :: atom()
  defp http_client, do: Application.get_env(:soroban, :http_client, :hackney)

  @spec json_library() :: module()
  defp json_library, do: Application.get_env(:soroban, :json_library, Jason)

  @spec http_options(options :: Keyword.t()) :: Keyword.t()
  defp http_options(options) do
    default_options = [recv_timeout: 30_000, follow_redirect: true]
    override_options = Application.get_env(:soroban, :hackney_options, [])

    default_options
    |> Keyword.merge(override_options)
    |> Keyword.merge(options)
    |> (&[:with_body | &1]).()
  end

  @spec request_body(endpoint :: String.t(), params :: map() | nil) :: map()
  defp request_body(endpoint, params) do
    %{
      jsonrpc: "2.0",
      id: 1,
      method: endpoint,
      params: params
    }
  end
end
