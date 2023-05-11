defmodule Soroban.Contract do
  @moduledoc """
  Exposes the function to invoke Soroban smart contracts
  """

  alias Soroban.Contract.{InstallContractCode, InvokeContractFunction}

  defdelegate invoke(
                contract_id,
                source_secret_key,
                function_name,
                function_args \\ [],
                auth_accounts \\ []
              ),
              to: InvokeContractFunction,
              as: :invoke

  defdelegate install(
                wasm,
                source_secret_key
              ),
              to: InstallContractCode,
              as: :install
end
