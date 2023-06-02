defmodule Soroban.Contract.DeployAssetContract do
  @moduledoc """
  `DeployAssetContract` implementation to deploy contract from an Asset.
  """
  alias Soroban.RPC.{GetTransactionResponse, SendTransactionResponse}
  alias Stellar.Horizon.Accounts

  alias Stellar.TxBuild.{
    Account,
    Asset,
    HostFunction,
    HostFunctionArgs,
    InvokeHostFunction,
    SequenceNumber,
    Signature
  }

  alias Soroban.Contract.RPCCalls
  alias StellarBase.XDR.TransactionResult

  @type asset :: Asset.t()
  @type asset_code :: binary()
  @type envelope_xdr :: String.t()
  @type invoke_host_function :: InvokeHostFunction.t()
  @type secret_key :: binary()
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type transaction_response :: {:ok, GetTransactionResponse.t()}

  @spec deploy(asset_code :: asset_code(), secret_key :: secret_key()) :: send_response()
  def deploy(asset_code, secret_key) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         %Account{} = source_account <- Account.new(public_key),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %Signature{} = signature <- Signature.new(keypair),
         %Asset{} = asset <- Asset.new(code: asset_code, issuer: public_key),
         %InvokeHostFunction{} = invoke_host_function_op <- create_host_function_deploy_op(asset) do
      invoke_host_function_op
      |> RPCCalls.simulate(source_account, sequence_number)
      |> RPCCalls.send_transaction(
        source_account,
        sequence_number,
        signature,
        invoke_host_function_op
      )
    end
  end

  @spec retrieve_unsigned_xdr_to_deploy_asset(
          asset_code :: asset_code(),
          source_public_key :: binary()
        ) :: envelope_xdr()
  def retrieve_unsigned_xdr_to_deploy_asset(asset_code, source_public_key) do
    with {:ok, seq_num} <- Accounts.fetch_next_sequence_number(source_public_key),
         %Account{} = source_account <- Account.new(source_public_key),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %Asset{} = asset <- Asset.new(code: asset_code, issuer: source_public_key),
         %InvokeHostFunction{} = invoke_host_function_op <-
           create_host_function_deploy_op(asset) do
      invoke_host_function_op
      |> RPCCalls.simulate(source_account, sequence_number)
      |> RPCCalls.retrieve_unsigned_xdr(source_account, sequence_number, invoke_host_function_op)
    end
  end

  @spec get_contract_id(transaction_response :: transaction_response()) :: binary()
  def get_contract_id({:ok, %GetTransactionResponse{result_xdr: result_xdr}}) do
    {%{
       result: %{
         value: %{
           operations: [%{result: %{result: %{value: %{items: [%{value: %{value: value}}]}}}}]
         }
       }
     }, ""} = result_xdr |> Base.decode64!() |> TransactionResult.decode_xdr!()

    Base.encode16(value, case: :lower)
  end

  @spec create_host_function_deploy_op(asset :: asset()) :: invoke_host_function()
  defp create_host_function_deploy_op(asset) do
    function_args =
      HostFunctionArgs.new(
        type: :create,
        asset: asset
      )

    function = HostFunction.new(args: function_args)
    InvokeHostFunction.new(functions: [function])
  end
end
