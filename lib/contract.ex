defmodule Soroban.Contract do
  @moduledoc """
  Exposes the function to invoke Soroban smart contracts
  """

  alias Soroban.Contract.{
    DeployAssetContract,
    DeployContract,
    ExtendFootprintTTL,
    InvokeContractFunction,
    RestoreFootprint,
    UploadContractCode
  }

  defdelegate invoke(
                server,
                network_passphrase,
                contract_address,
                source_secret_key,
                function_name,
                function_args \\ [],
                auth_secret_keys \\ [],
                addl_resources \\ []
              ),
              to: InvokeContractFunction,
              as: :invoke

  defdelegate simulate_invoke(
                server,
                network_passphrase,
                contract_address,
                source_public_key,
                function_name,
                function_args \\ [],
                addl_resources \\ []
              ),
              to: InvokeContractFunction,
              as: :simulate_invoke

  defdelegate upload(
                server,
                network_passphrase,
                wasm,
                source_secret_key,
                addl_resources \\ []
              ),
              to: UploadContractCode,
              as: :upload

  defdelegate deploy(
                server,
                network_passphrase,
                wasm_id,
                source_secret_key,
                addl_resources \\ []
              ),
              to: DeployContract,
              as: :deploy

  defdelegate deploy_asset(
                server,
                network_passphrase,
                asset_code,
                asset_issuer,
                source_secret_key,
                addl_resources \\ []
              ),
              to: DeployAssetContract,
              as: :deploy

  defdelegate extend_contract(
                server,
                network_passphrase,
                contract_address,
                secret_key,
                ledgers_to_extend,
                addl_resources \\ []
              ),
              to: ExtendFootprintTTL,
              as: :extend_contract

  defdelegate extend_contract_wasm(
                server,
                network_passphrase,
                wasm_id,
                secret_key,
                ledgers_to_extend,
                addl_resources \\ []
              ),
              to: ExtendFootprintTTL,
              as: :extend_contract_wasm

  defdelegate extend_contract_keys(
                server,
                network_passphrase,
                contract_address,
                secret_key,
                ledgers_to_extend,
                keys,
                addl_resources \\ []
              ),
              to: ExtendFootprintTTL,
              as: :extend_contract_keys

  defdelegate restore_contract(
                server,
                network_passphrase,
                contract_address,
                secret_key,
                addl_resources \\ []
              ),
              to: RestoreFootprint,
              as: :restore_contract

  defdelegate restore_contract_wasm(
                server,
                network_passphrase,
                wasm_id,
                secret_key,
                addl_resources \\ []
              ),
              to: RestoreFootprint,
              as: :restore_contract_wasm

  defdelegate restore_contract_keys(
                server,
                network_passphrase,
                contract_address,
                secret_key,
                keys,
                addl_resources \\ []
              ),
              to: RestoreFootprint,
              as: :restore_contract_keys

  defdelegate retrieve_unsigned_xdr_to_invoke(
                server,
                network_passphrase,
                contract_address,
                source_public_key,
                function_name,
                function_args \\ [],
                addl_resources \\ []
              ),
              to: InvokeContractFunction,
              as: :retrieve_unsigned_xdr_to_invoke

  defdelegate retrieve_unsigned_xdr_to_upload(
                server,
                network_passphrase,
                wasm,
                source_public_key,
                addl_resources \\ []
              ),
              to: UploadContractCode,
              as: :retrieve_unsigned_xdr_to_upload

  defdelegate retrieve_unsigned_xdr_to_deploy(
                server,
                network_passphrase,
                wasm_id,
                source_public_key,
                addl_resources \\ []
              ),
              to: DeployContract,
              as: :retrieve_unsigned_xdr_to_deploy

  defdelegate retrieve_unsigned_xdr_to_deploy_asset(
                server,
                network_passphrase,
                asset_code,
                source_public_key,
                addl_resources \\ []
              ),
              to: DeployAssetContract,
              as: :retrieve_unsigned_xdr_to_deploy_asset
end
