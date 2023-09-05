defmodule Soroban.Contract do
  @moduledoc """
  Exposes the function to invoke Soroban smart contracts
  """

  alias Soroban.Contract.{
    BumpFootprintExpiration,
    DeployAssetContract,
    DeployContract,
    InvokeContractFunction,
    RestoreFootprint,
    UploadContractCode
  }

  defdelegate invoke(
                contract_address,
                source_secret_key,
                function_name,
                function_args \\ [],
                fix_fee \\ 0.0,
                auth_secret_keys \\ []
              ),
              to: InvokeContractFunction,
              as: :invoke

  defdelegate simulate_invoke(
                contract_address,
                source_public_key,
                function_name,
                function_args \\ []
              ),
              to: InvokeContractFunction,
              as: :simulate_invoke

  defdelegate upload(
                wasm,
                source_secret_key
              ),
              to: UploadContractCode,
              as: :upload

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

  defdelegate bump_contract(contract_address, secret_key, ledgers_to_bump),
    to: BumpFootprintExpiration,
    as: :bump_contract

  defdelegate bump_contract_wasm(wasm_id, secret_key, ledgers_to_bump),
    to: BumpFootprintExpiration,
    as: :bump_contract_wasm

  defdelegate bump_contract_keys(contract_address, secret_key, ledgers_to_bump, keys),
    to: BumpFootprintExpiration,
    as: :bump_contract_keys

  defdelegate restore_contract(contract_address, secret_key),
    to: RestoreFootprint,
    as: :restore_contract

  defdelegate restore_contract_wasm(wasm_id, secret_key),
    to: RestoreFootprint,
    as: :restore_contract_wasm

  defdelegate restore_contract_keys(contract_address, secret_key, keys),
    to: RestoreFootprint,
    as: :restore_contract_keys

  defdelegate retrieve_unsigned_xdr_to_invoke(
                contract_address,
                source_public_key,
                function_name,
                function_args \\ [],
                fix_fee \\ 0.0
              ),
              to: InvokeContractFunction,
              as: :retrieve_unsigned_xdr_to_invoke

  defdelegate retrieve_unsigned_xdr_to_upload(
                wasm,
                source_public_key
              ),
              to: UploadContractCode,
              as: :retrieve_unsigned_xdr_to_upload

  defdelegate retrieve_unsigned_xdr_to_deploy(
                wasm_id,
                source_public_key
              ),
              to: DeployContract,
              as: :retrieve_unsigned_xdr_to_deploy

  defdelegate retrieve_unsigned_xdr_to_deploy_asset(
                asset_code,
                source_public_key
              ),
              to: DeployAssetContract,
              as: :retrieve_unsigned_xdr_to_deploy_asset
end
