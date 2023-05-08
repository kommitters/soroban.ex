defmodule Soroban.Contract do
  @moduledoc """
  Exposes the function to invoke Soroban smart contracts
  """

  alias Soroban.Contract.InvokeHostFunction

  defdelegate invoke(
                contract_id,
                source_secret_key,
                function_name,
                function_args,
                auth_accounts \\ []
              ),
              to: InvokeHostFunction,
              as: :invoke
end
