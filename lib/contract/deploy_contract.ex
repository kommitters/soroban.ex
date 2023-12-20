defmodule Soroban.Contract.DeployContract do
  @moduledoc """
  `DeployContract` implementation to deploy contract from a wasm file.
  """
  alias Soroban.RPC.SendTransactionResponse
  alias Stellar.Horizon.Accounts

  alias Stellar.TxBuild.{
    Account,
    ContractExecutable,
    ContractIDPreimage,
    ContractIDPreimageFromAddress,
    CreateContractArgs,
    HostFunction,
    InvokeHostFunction,
    SCAddress,
    SequenceNumber,
    Signature
  }

  alias Soroban.Contract.RPCCalls

  @type envelope_xdr :: String.t()
  @type public_key :: String.t()
  @type wasm_id :: binary()
  @type invoke_host_function :: InvokeHostFunction.t()
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type addl_resources :: keyword()

  @spec deploy(wasm_id :: wasm_id(), secret_key :: binary(), addl_resources :: addl_resources()) ::
          send_response()
  def deploy(wasm_id, secret_key, addl_resources \\ []) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         %Account{} = source_account <- Account.new(public_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %Signature{} = signature <- Signature.new(keypair),
         %InvokeHostFunction{} = invoke_host_function_op <-
           create_host_function_deploy_op(wasm_id, public_key) do
      invoke_host_function_op
      |> RPCCalls.simulate(source_account, sequence_number, addl_resources)
      |> RPCCalls.send_transaction(
        source_account,
        sequence_number,
        signature,
        invoke_host_function_op
      )
    end
  end

  @spec retrieve_unsigned_xdr_to_deploy(
          wasm_id :: wasm_id(),
          source_public_key :: binary(),
          addl_resources :: addl_resources()
        ) :: envelope_xdr()
  def retrieve_unsigned_xdr_to_deploy(wasm_id, source_public_key, addl_resources \\ []) do
    with {:ok, seq_num} <- Accounts.fetch_next_sequence_number(source_public_key),
         %Account{} = source_account <- Account.new(source_public_key),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %InvokeHostFunction{} = invoke_host_function_op <-
           create_host_function_deploy_op(wasm_id, source_public_key) do
      invoke_host_function_op
      |> RPCCalls.simulate(source_account, sequence_number, addl_resources)
      |> RPCCalls.retrieve_unsigned_xdr(source_account, sequence_number, invoke_host_function_op)
    end
  end

  @spec create_host_function_deploy_op(wasm_id :: wasm_id(), public_key :: public_key()) ::
          invoke_host_function()
  defp create_host_function_deploy_op(wasm_id, public_key) do
    address = SCAddress.new(public_key)
    salt = :crypto.strong_rand_bytes(32)
    address_preimage = ContractIDPreimageFromAddress.new(address: address, salt: salt)
    contract_id_preimage = ContractIDPreimage.new(from_address: address_preimage)
    contract_executable = ContractExecutable.new(wasm_ref: wasm_id)

    create_contract_args =
      CreateContractArgs.new(
        contract_id_preimage: contract_id_preimage,
        contract_executable: contract_executable
      )

    host_function = HostFunction.new(create_contract: create_contract_args)

    InvokeHostFunction.new(host_function: host_function)
  end
end
