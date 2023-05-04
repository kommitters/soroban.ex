defmodule Soroban.RPC do
  @moduledoc """
  Exposes functions to interact with the Soroban API requests.
  """

  alias Soroban.RPC.{SendTransaction, SimulateTransaction}

  defdelegate send_transaction(base64_envelope), to: SendTransaction, as: :request
  defdelegate simulate_transaction(base64_envelope), to: SimulateTransaction, as: :request
end
