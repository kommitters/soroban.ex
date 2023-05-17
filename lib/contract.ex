defmodule Soroban.Contract do
  @moduledoc """
  Exposes the function to invoke Soroban smart contracts
  """

  alias Soroban.Contract.{
    DeployAssetContract,
    DeployContract,
    InstallContractCode,
    InvokeContractFunction
  }

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

  defdelegate deploy(
                wasm_id,
                source_secret_key
              ),
              to: DeployContract,
              as: :deploy

  defdelegate deploy_asset(
                asset_code,
                source_secret_key
              ),
              to: DeployAssetContract,
              as: :deploy

  defdelegate retrieve_xdr_to_sign(
                contract_id,
                source_public_key,
                function_name,
                function_args \\ []
              ),
              to: InvokeContractFunction,
              as: :retrieve_xdr_to_sign
end
