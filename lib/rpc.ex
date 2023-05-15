defmodule Soroban.RPC do
  @moduledoc """
  Exposes functions to interact with the Soroban API requests.
  """

  alias Soroban.RPC.{GetTransaction, SendTransaction, SimulateTransaction}

  defdelegate send_transaction(base64_envelope), to: SendTransaction, as: :request
  defdelegate simulate_transaction(base64_envelope), to: SimulateTransaction, as: :request
  defdelegate get_transaction(hash), to: GetTransaction, as: :request
end
