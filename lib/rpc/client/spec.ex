defmodule Soroban.RPC.Client.Spec do
  @moduledoc """
  Specifies expected behaviour of an HTTP client.
  """

  alias Soroban.RPC.{Error, HTTPError}

  @type endpoint :: String.t()
  @type headers :: [{binary(), binary()}, ...]
  @type options :: Keyword.t()
  @type params :: map() | nil
  @type success_response :: {:ok, map()}
  @type error_response :: {:error, Error.t() | HTTPError.t()}

  @callback request(
              endpoint :: endpoint(),
              url :: binary(),
              headers :: headers(),
              params :: params(),
              options :: options()
            ) :: success_response() | error_response()
end
